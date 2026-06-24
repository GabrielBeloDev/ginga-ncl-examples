-- compat.lua
-- Restaura funcoes do Lua 5.1 (module, setfenv, getfenv, package.seeall) que foram
-- REMOVIDAS no Lua 5.2+. O Ginga atual embarca Lua 5.3, entao os scripts originais
-- (escritos para Lua 5.1) quebravam logo no carregamento com:
--     "attempt to call a nil value (global 'module')".
-- Este shim NAO altera a logica dos apps: apenas reativa as APIs que eles esperam,
-- usando a biblioteca `debug` para reproduzir a troca de ambiente (_ENV) do Lua 5.1.
-- Uso: carregue-o ANTES de qualquer outro require, com:  require "compat"

assert(debug and debug.getupvalue and debug.upvaluejoin,
  "compat.lua: biblioteca 'debug' indisponivel; nao da para emular module()/setfenv()")

-- Troca o _ENV (ambiente) de uma funcao ja existente (equivalente ao setfenv do 5.1).
local function set_env(fn, env)
  local i = 1
  while true do
    local name = debug.getupvalue(fn, i)
    if name == "_ENV" then
      debug.upvaluejoin(fn, i, function() return env end, 1)
      return fn
    elseif not name then
      return fn
    end
    i = i + 1
  end
end

if setfenv == nil then
  function setfenv(f, env)
    if type(f) == "number" then
      if f == 0 then return end
      f = debug.getinfo(f + 1, "f").func
    end
    return set_env(f, env)
  end
end

if getfenv == nil then
  function getfenv(f)
    if type(f) == "number" then f = debug.getinfo(f + 1, "f").func end
    if type(f) ~= "function" then return _G end
    local i = 1
    while true do
      local name, val = debug.getupvalue(f, i)
      if name == "_ENV" then return val elseif not name then return _G end
      i = i + 1
    end
  end
end

if package.seeall == nil then
  function package.seeall(M)
    local mt = getmetatable(M)
    if not mt then mt = {}; setmetatable(M, mt) end
    mt.__index = _G
  end
end

if module == nil then
  function module(name, ...)
    local M = package.loaded[name]
    if not M then M = {}; package.loaded[name] = M end
    _G[name] = M
    M._NAME = name
    M._M = M
    for _, option in ipairs({...}) do option(M) end
    -- seeall por padrao (seguro: so permite LER os globais, nunca bloqueia)
    if not getmetatable(M) then setmetatable(M, {__index = _G}) end
    -- direciona os globais definidos pelo chunk chamador para a tabela do modulo
    set_env(debug.getinfo(2, "f").func, M)
  end
end
