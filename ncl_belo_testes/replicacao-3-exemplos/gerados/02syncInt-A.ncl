<?xml version="1.0" encoding="UTF-8"?>
<!--
  Garrincha video-tribute - self-contained Ginga-NCL 3.0 (EDTV profile).
  Automatic synchronism anchored on the main video (animGar.mp4) time line,
  plus one colored-key (RED) interaction over the icon.
  All regions, descriptors, causal connectors and links are defined inline.
  Media referenced by bare filename (no subfolder).
-->
<ncl id="garrinchaTribute" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ================= LAYOUT (positions in % of the screen) ================= -->
    <regionBase>
      <!-- Background: lowest layer -->
      <region id="rgBackground" left="0%" top="0%" width="100%" height="100%" zIndex="1"/>
      <!-- Main screen: full screen, bounds changeable at runtime -->
      <region id="rgMain" left="0%" top="0%" width="100%" height="100%" zIndex="2"/>
      <!-- Frame box (top-left), shared by drible.mp4 and photo.png -->
      <region id="rgFrame" left="5%" top="6.7%" width="18.5%" height="18.5%" zIndex="3"/>
      <!-- Icon box (top-right) for icon.png -->
      <region id="rgIcon" left="87.5%" top="11.7%" width="8.45%" height="6.7%" zIndex="3"/>
      <!-- Ad box (bottom-left) for shoes.mp4 -->
      <region id="rgAd" left="15%" top="60%" width="25%" height="25%" zIndex="3"/>
    </regionBase>

    <!-- ================= DESCRIPTORS ================= -->
    <descriptorBase>
      <descriptor id="dBackground" region="rgBackground"/>
      <descriptor id="dMain" region="rgMain"/>
      <!-- choro.mp4 used as audio only: descriptor without region -->
      <descriptor id="dChoro"/>
      <descriptor id="dDrible" region="rgFrame"/>
      <!-- photo.png explicit duration of 5s -->
      <descriptor id="dPhoto" region="rgFrame" explicitDur="5s"/>
      <!-- icon.png explicit duration of 6s and focusable so RED can select it -->
      <descriptor id="dIcon" region="rgIcon" explicitDur="6s" focusIndex="1"/>
      <descriptor id="dAd" region="rgAd"/>
    </descriptorBase>

    <!-- ================= CAUSAL CONNECTORS ================= -->
    <connectorBase>
      <!-- onBegin -> start (one or more targets, in parallel) -->
      <causalConnector id="onBeginStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> stop (one or more targets, in parallel) -->
      <causalConnector id="onEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> set a property to a given value -->
      <causalConnector id="onEndSet">
        <connectorParam name="var"/>
        <simpleCondition role="onEnd"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>

      <!-- onSelection(key) -> stop, set bounds, start (sequential) -->
      <causalConnector id="onRedSelection">
        <connectorParam name="keyCode"/>
        <connectorParam name="boundsVal"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$boundsVal"/>
          <simpleAction role="start"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- Entry point: the document starts by the main video at t=0 (full screen). -->
    <port id="pEntry" component="animGar"/>

    <!-- ================= MEDIA OBJECTS ================= -->
    <media id="background" src="background.png" descriptor="dBackground"/>

    <!-- Main video: time anchor of all synchronism; bounds property changeable at runtime -->
    <media id="animGar" src="animGar.mp4" descriptor="dMain">
      <property name="bounds"/>
      <area id="a5"  begin="5s"/>
      <area id="a12" begin="12s"/>
      <area id="a41" begin="41s"/>
      <area id="a45" begin="45s"/>
    </media>

    <media id="choro"  src="choro.mp4"  descriptor="dChoro"/>
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>
    <media id="photo"  src="photo.png"  descriptor="dPhoto"/>
    <media id="icon"   src="icon.png"   descriptor="dIcon"/>
    <media id="shoes"  src="shoes.mp4"  descriptor="dAd"/>

    <!-- ================= SYNCHRONISM (anchored on animGar time) ================= -->

    <!-- t=5s: start background + choro (in parallel) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a5"/>
      <bind role="start" component="background"/>
      <bind role="start" component="choro"/>
    </link>

    <!-- t=12s: start drible in the frame box (natural clip duration) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a12"/>
      <bind role="start" component="drible"/>
    </link>

    <!-- t=41s: show photo in the frame box for 5s (explicit duration) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a41"/>
      <bind role="start" component="photo"/>
    </link>

    <!-- t=45s: show icon in the icon box for 6s (interaction window) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a45"/>
      <bind role="start" component="icon"/>
    </link>

    <!-- End of main video: stop background + choro (in parallel); program ends -->
    <link xconnector="onEndStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop" component="background"/>
      <bind role="stop" component="choro"/>
    </link>

    <!-- ================= INTERACTION (RED key over the icon) ================= -->
    <!-- While icon is visible (45-51s), pressing RED: stop icon, shrink main
         video to a reduced top-left window (revealing background), start the ad. -->
    <link xconnector="onRedSelection">
      <bind role="onSelection" component="icon">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="stop" component="icon"/>
      <bind role="set" component="animGar" interface="bounds">
        <bindParam name="boundsVal" value="5%,6.67%,45%,45%"/>
      </bind>
      <bind role="start" component="shoes"/>
    </link>

    <!-- When the ad ends: restore the main video to full screen. -->
    <link xconnector="onEndSet">
      <bind role="onEnd" component="shoes"/>
      <bind role="set" component="animGar" interface="bounds">
        <bindParam name="var" value="0,0,222.22%,222.22%"/>
      </bind>
    </link>

  </body>
</ncl>
