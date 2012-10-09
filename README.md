fsPhoneLite
===========

fsPhone is an flex softPhone designed for freeSWITCH, working with mod_rtmp by rtmp connection.

fsPhoneLite support basic call functionality. In additon, it implemented an simple esl to interact with freeSWITCH's mod_event_sokect.

Development Environment:<br>
flex sdk 4.5<br>
flash player 10.3

Acknowledge:<br>
flex ESL from fsair written by Seven DU<br>
fsPhone's UI is based on an open source project named red5phone

NOTICE in compile:<br>
additional compiler arguments in Flex Compiler:<br>
-locale zh_CN en_US -swf-version=12 -theme=${flexlib}/themes/Halo/halo.swc<br>
add Folder in Flex Build Path:<br>
resources/locale/{locale}<br>

Others:<br>
fsPhoneLite.html is an example to load fsPhoneLite in html page<br>

Since the security policy of flash, exception will be threw out when connecting to mod_event_socket of freeSWITCH directly. Running the ruby script "crossdomain.rb" (thanks to Seven Du) on the freeSWITCH server will be an solution.<br>

freeSWITCH:
load mod_rtmp<br>
event socket should listen on fsPhoneLite's IP<br>
edit fs' dialplan to enable inCommingCall of fsPhoneLite:<br>
<pre>
<action application="bridge" data="${rtmp_contact($${rtmp_profile}/${dialed_ext}@$${domain})}"/>
</pre>

![first img](http://github.com/dalang/fsPhoneLite/raw/master/screenshot/00.png)


![second img](http://github.com/dalang/fsPhoneLite/raw/master/screenshot/01png)


![third img](http://github.com/dalang/fsPhoneLite/raw/master/screenshot/02.png)

