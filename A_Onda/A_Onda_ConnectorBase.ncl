<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Generated	by NCL Eclipse -->
<ncl id="A_Onda_ConnectorBase" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
    <head>
        <connectorBase>
            <causalConnector id="onBeginStart">
                <simpleCondition role="onBegin"/>
                <simpleAction role="start" max="unbounded" qualifier="seq"/>
            </causalConnector>

            <causalConnector id="onBeginSet">
                <connectorParam name="var" />
                <simpleCondition role="onBegin" />
                <simpleAction role="set" value="$var" max="unbounded" qualifier="seq" />
            </causalConnector>

            <causalConnector id="onBeginSetStart">
                <connectorParam name="var" />
                <simpleCondition role="onBegin" />
                <compoundAction operator="seq">
                    <simpleAction role="set" value="$var" max="unbounded" qualifier="seq"/>
                    <simpleAction role="start" max="unbounded" qualifier="seq"/>
                </compoundAction>
            </causalConnector>

            <causalConnector id="onEndStart">
                <simpleCondition role="onEnd"/>
                <simpleAction role="start" max="unbounded" qualifier="seq"/>
            </causalConnector>

            <causalConnector id="onEndSet">
                <connectorParam name="var" />
                <simpleCondition role="onEnd"/>
                <simpleAction role="set" value="$var" max="unbounded" qualifier="seq"/>
            </causalConnector>

            <causalConnector id="onEndStop">
                <simpleCondition role="onEnd"/>
                <simpleAction role="stop" max="unbounded" qualifier="par"/>
            </causalConnector>

            <causalConnector id="onEndStopStart">
                <simpleCondition role="onEnd"/>
                <compoundAction operator="seq">
                    <simpleAction role="stop" max="unbounded" qualifier="par"/>
                    <simpleAction role="start" max="unbounded" qualifier="par"/>
                </compoundAction>
            </causalConnector>

            <causalConnector id="onEndAbort">
                <simpleCondition role="onEnd"/>
                <simpleAction role="abort" max="unbounded" qualifier="par"/>
            </causalConnector>

            <causalConnector id="onKeySelectionStartStop">
                <connectorParam name="keyCode"/>
                <simpleCondition role="onSelection" key="$keyCode" max="unbounded" qualifier="or"/>
                <compoundAction operator="seq">
                    <simpleAction role="stop" max="unbounded" qualifier="seq"/>
                    <simpleAction role="start" max="unbounded" qualifier="seq"/>
                </compoundAction>
            </causalConnector>

            <causalConnector id="onKeySelectionStopSetStart">
                <connectorParam name="keyCode"/>
                <connectorParam name="var"/>
                <simpleCondition role="onSelection" key="$keyCode"/>
                <compoundAction operator="seq">
                    <simpleAction role="stop" max="unbounded" qualifier="seq"/>
                    <simpleAction role="set" value="$var" max="unbounded" qualifier="seq"/>
                    <simpleAction role="start" max="unbounded" qualifier="seq"/>
                </compoundAction>
            </causalConnector>

            <causalConnector id="onKeySelectionStopStart">
                <connectorParam name="keyCode"/>
                <simpleCondition role="onSelection" key="$keyCode"/>
                <compoundAction operator="seq">
                    <simpleAction role="stop" max="unbounded" qualifier="seq"/>
                    <simpleAction role="start" max="unbounded" qualifier="seq"/>
                </compoundAction>
            </causalConnector>

            <causalConnector id="onOrKeySelectionSetStop">
                <connectorParam name="keyCode" />
                <connectorParam name="var"/>
                <simpleCondition role="onSelection" key="$keyCode" qualifier="or" max="unbounded"/>
                <compoundAction operator="seq">
                    <simpleAction role="set" value="$var" max="unbounded" qualifier="par"/>
                    <simpleAction role="stop" max="unbounded" qualifier="seq" />
                </compoundAction>
            </causalConnector>

            <causalConnector id="onKeySelectionStop">
                <connectorParam name="keyCode" />
                <simpleCondition role="onSelection" key="$keyCode" qualifier="or" max="unbounded"/>
                <simpleAction role="stop" max="unbounded" qualifier="seq" />
            </causalConnector>

            <causalConnector id="onOrKeySelectionStopSet">
                <connectorParam name="keyCode" />
                <connectorParam name="var"/>
                <simpleCondition role="onSelection" key="$keyCode" qualifier="or" max="unbounded"/>
                <compoundAction operator="seq">
                    <simpleAction role="stop" max="unbounded" qualifier="seq" />
                    <simpleAction role="set" value="$var" max="unbounded" qualifier="par"/>
                </compoundAction>
            </causalConnector>

            <causalConnector id="onEndAttributionCmpStopStart">
                <connectorParam name="val"/>
                <compoundCondition operator="and">
                    <simpleCondition role="onEndAttribution"/>
                    <assessmentStatement comparator="eq">
                        <attributeAssessment role="cmpVal" eventType="attribution" attributeType="nodeProperty"/>
                        <valueAssessment value="$val"/>
                    </assessmentStatement>
                </compoundCondition>
                <compoundAction operator="seq">
                    <simpleAction role="stop" max="unbounded" qualifier="seq"/>
                    <simpleAction role="start" max="unbounded" delay="0.5s" qualifier="seq"/>
                </compoundAction>
            </causalConnector>

        </connectorBase>
    </head>
</ncl>
