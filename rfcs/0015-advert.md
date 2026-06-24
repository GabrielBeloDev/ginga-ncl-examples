# RFC-0015: Inserção de propaganda (advertisement) acionada por seleção

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/advert.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/advert.png`](../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/advert.png) |

## 1. Resumo
Este documento demonstra a **inserção de uma propaganda interativa** em uma aplicação de TV digital escrita em NCL 3.0 (perfil EDTV). Um ícone permanente na tela funciona como gatilho: ao ser selecionado pelo telespectador (tecla OK do controle remoto), o ícone é encerrado e dispara, em paralelo, a peça publicitária completa — fundo, vídeo do produto (tênis) e um formulário HTML interativo. Quando o formulário chega ao fim de sua duração, toda a aplicação é encerrada. O exemplo ilustra **interação por seleção**, **disparo paralelo de mídias** e **encerramento do contexto raiz** via elos causais com conectores importados.

## 2. Conceitos NCL demonstrados
- **Regiões aninhadas** (`<region>` filhas dentro de uma região de fundo) com `zIndex` para empilhamento.
- **Descritores** com `explicitDur` (duração explícita) e `focusIndex` (navegação por foco).
- **Conectores causais importados** via `<importBase>` + `alias` (reúso de uma base externa de conectores).
- **Interação por seleção** (`onSelection`) acionada pela tecla OK.
- **Ações compostas em paralelo** (`qualifier="par"`, `max="unbounded"`): um único elo inicia várias mídias ao mesmo tempo.
- **Encerramento do contexto raiz** (`<bind role="stop" component="adv"/>` aplicado ao próprio `<body>`) ao fim de uma mídia.
- **Mídias heterogêneas**: imagem PNG, vídeo MP4 e documento HTML (`.htm`) coexistindo na mesma cena.

## 3. Estrutura do documento

### 3.1 Layout — regiões e descritores

**Regiões** (`<regionBase>`):

| Região | Geometria | zIndex | Observação |
|--------|-----------|--------|------------|
| `backgroundReg` | `width=100%`, `height=100%` | 5 | região-mãe que cobre a tela inteira (fundo da propaganda) |
| `iconReg` | `width=100%`, `height=100%` | 6 | aninhada em `backgroundReg`; ocupa toda a tela (mostra o ícone-gatilho) |
| `shoesReg` | `left=5%`, `top=30%`, `width=40%`, `height=40%` | 6 | aninhada; metade esquerda, recebe o vídeo do produto |
| `formReg` | `left=50%`, `top=5%`, `width=45%`, `height=90%` | 6 | aninhada; metade direita, recebe o formulário HTML |

As três regiões filhas (`iconReg`, `shoesReg`, `formReg`) estão **aninhadas** dentro de `backgroundReg` e compartilham `zIndex="6"`, ficando todas acima do fundo (`zIndex="5"`).

**Descritores** (`<descriptorBase>`):

| Descritor | Região | Atributos |
|-----------|--------|-----------|
| `backgroundDesc` | `backgroundReg` | `explicitDur="12s"` |
| `iconDesc` | `iconReg` | `explicitDur="6s"`, `focusIndex="1"` |
| `shoesDesc` | `shoesReg` | — (sem duração explícita; segue a duração natural do vídeo) |
| `formDesc` | `formReg` | `focusIndex="2"`, `explicitDur="12s"` |

O `iconDesc` recebe `focusIndex="1"`, tornando o ícone o elemento focável inicial e selecionável pela tecla OK. O `formDesc` (`focusIndex="2"`) deixa o formulário também navegável.

### 3.2 Conectores

Os conectores **não são definidos localmente**: o documento importa a base externa `causalConnBase.ncl` com o alias `conEx`:

```xml
<connectorBase>
  <importBase documentURI="causalConnBase.ncl" alias="conEx"/>
</connectorBase>
```

Dois conectores dessa base são efetivamente usados:

- **`conEx#onSelectionStopStart`** — condição `onSelection` (seleção via OK) e ação composta sequencial (`operator="seq"`) com dois passos, ambos em paralelo e ilimitados (`qualifier="par"`, `max="unbounded"`):
  1. `role="stop"` — para a(s) mídia(s) ligada(s) ao papel de parada;
  2. `role="start"` — inicia a(s) mídia(s) ligada(s) ao papel de início.

  ```xml
  <causalConnector id="onSelectionStopStart">
    <simpleCondition role="onSelection"/>
    <compoundAction operator="seq">
      <simpleAction role="stop"  max="unbounded" qualifier="par"/>
      <simpleAction role="start" max="unbounded" qualifier="par"/>
    </compoundAction>
  </causalConnector>
  ```

- **`conEx#onEndStop`** — condição `onEnd` (fim natural/explícito de uma mídia) e ação simples `role="stop"` em paralelo/ilimitada:

  ```xml
  <causalConnector id="onEndStop">
    <simpleCondition role="onEnd"/>
    <simpleAction role="stop" max="unbounded" qualifier="par"/>
  </causalConnector>
  ```

(A base `causalConnBase.ncl` contém ainda muitos outros conectores — `onBeginStart`, `onEndStart`, `onKeySelectionStopStart`, variantes com `set`/`delay`, etc. — mas apenas os dois acima são referenciados por este documento.)

### 3.3 Mídias

| Mídia (`id`) | `src` | Descritor | Papel na cena |
|--------------|-------|-----------|---------------|
| `icon` | `../media/iconPassive.png` | `iconDesc` | ícone-gatilho permanente (focável) |
| `background` | `../media/backgroundPassive.png` | `backgroundDesc` | imagem de fundo da propaganda |
| `shoes` | `../media/shoes.mp4` | `shoesDesc` | vídeo do produto (tênis) |
| `ptForm` | `../media/ptForm.htm` | `formDesc` | formulário HTML interativo |

A âncora de entrada da aplicação é a porta `<port id="pIcon" component="icon"/>`, ou seja, **o ícone é a primeira mídia a iniciar**. Não há `<area>` nem `<property>` declaradas nas mídias; toda a temporização vem dos `explicitDur` dos descritores e da duração natural do vídeo.

### 3.4 Elos e temporização

**Elo 1 — `lBegingAdvert`** (disparo da propaganda por seleção):

```xml
<link id="lBegingAdvert" xconnector="conEx#onSelectionStopStart">
  <bind role="onSelection" component="icon"/>
  <bind role="stop"        component="icon"/>
  <bind role="start"       component="background"/>
  <bind role="start"       component="ptForm"/>
  <bind role="start"       component="shoes"/>
</link>
```

Condição → ação: quando o telespectador **seleciona o `icon`** (`onSelection`), o elo **para o próprio `icon`** e, em paralelo, **inicia `background`, `ptForm` e `shoes`**. Como o conector usa `max="unbounded"`/`qualifier="par"`, as três mídias da propaganda entram em cena simultaneamente.

**Elo 2** (encerramento da aplicação ao fim do formulário):

```xml
<link xconnector="conEx#onEndStop">
  <bind role="onEnd" component="ptForm"/>
  <bind role="stop"  component="adv"/>
</link>
```

Condição → ação: quando `ptForm` chega ao fim (seu descritor tem `explicitDur="12s"`), o elo executa `stop` sobre **`adv`** — que é o `id` do próprio `<body>` (o contexto raiz). Isso **encerra toda a aplicação**, parando juntas as demais mídias ainda ativas.

**Linha do tempo resumida:**
1. `t=0` — entra apenas o `icon` (via porta `pIcon`); ele tem `explicitDur="6s"`.
2. O telespectador **pressiona OK** sobre o ícone → ícone para; `background` + `shoes` + `ptForm` iniciam em paralelo.
3. `background` e `ptForm` duram 12s (`explicitDur`); `shoes` roda pela duração natural do vídeo.
4. Ao fim de `ptForm` (`onEnd`), o `stop` no `adv` encerra a aplicação inteira.

## 4. Execução

```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga advert.ncl
```

**Comportamento esperado:** a aplicação inicia exibindo o ícone (gatilho) em tela cheia. Ao selecionar o ícone com a tecla OK do controle remoto, o ícone desaparece e surge a propaganda: imagem de fundo cobrindo a tela, o vídeo dos tênis na metade esquerda (`shoesReg`) e o formulário HTML interativo na metade direita (`formReg`). Após cerca de 12 segundos (fim do formulário), a aplicação é encerrada.

**Resultado verificado:** ✅ A aplicação carrega, o ícone é exibido e a seleção dispara corretamente o conjunto de mídias da propaganda em paralelo (fundo, vídeo e formulário lado a lado); o encerramento pelo `onEnd` do formulário ocorre como esperado — ver captura [`../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/advert.png`](../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/advert.png).

## 5. Observações
- **Mídias locais necessárias** (todas presentes em `../media/` relativo ao `.ncl`): `iconPassive.png`, `backgroundPassive.png`, `shoes.mp4`, `ptForm.htm`. A ausência de qualquer uma delas deixa a respectiva região vazia.
- **Dependência de base de conectores externa:** o documento **só funciona** com `causalConnBase.ncl` presente no mesmo diretório (`Exemplos/`), pois todos os `xconnector` apontam para o alias `conEx`. Os conectores `onSelectionStopStart` e `onEndStop` precisam existir nessa base (ambos confirmados).
- **`shoes.mp4` (~2,6 MB)** pode estar versionado via Git LFS; garanta o download efetivo do binário antes de executar, caso contrário o vídeo não renderiza.
- **Interatividade obrigatória:** a propaganda **não inicia sozinha** — depende da seleção do ícone pelo telespectador (`onSelection`). Sem o pressionamento de OK, apenas o ícone é exibido por 6s.
- **Encerramento via contexto raiz:** o `stop` é aplicado ao `id` do `<body>` (`adv`); essa técnica encerra todas as mídias do documento de uma só vez, dependendo do fim explícito (`explicitDur="12s"`) do formulário HTML.
- O comentário no topo do arquivo e o `id` do `<ncl>` (`_00prepPassiveDevicesEx`) sugerem que este exemplo é uma **preparação para o cenário de múltiplos dispositivos passivos** (NCL aninhado); aqui, porém, ele roda de forma autônoma em um único dispositivo.
- O arquivo `.ncl` está codificado em **ISO-8859-1** (Latin-1); os comentários contêm acentuação nessa codificação.
