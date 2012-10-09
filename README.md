fsPhoneLite
===========

fsPhone is an flex softPhone designed for freeSWITCH, working with mod_rtmp by rtmp connection.
fsPhoneLite support basic call functionality. In addition, it implemented an simple esl to interact with freeSWITCH's mod_event_sokect.

##Development Environment:<br>
**flex sdk 4.5**<br>
**flash player 10.3**

##NOTICE in compile:<br>
* additional compiler arguments in Flex Compiler:<br>
<pre>
    -locale zh_CN en_US -swf-version=12 -theme=${flexlib}/themes/Halo/halo.swc<br>
</pre>
* add Folder in Flex Build Path:<br>
<pre>
    resources/locale/{locale}<br>
</pre>
##Others:<br>
* fsPhoneLite.html is an example to load fsPhoneLite in html page<br>
* Since the security policy of flash, exception will be threw out when connecting to mod_event_socket of freeSWITCH directly. Running the ruby script "crossdomain.rb" (thanks to Seven Du) on the freeSWITCH server will be an solution.<br>

##freeSWITCH:<br>
* load mod_rtmp<br>
* event socket should listen on fsPhoneLite's IP<br>
* edit **fs' dialplan** to enable incommingCall of fsPhoneLite:<br>
<pre>&lt;action application="bridge" data="${rtmp_contact($${rtmp_profile}/${dialed_ext}@$${domain})}"/&gt;
</pre>
##Acknowledge:<br>
flex ESL based on fsair's written by Seven Du<br>
fsPhone's UI is based on an open source project named red5phone

![first img](http://github.com/dalang/fsPhoneLite/raw/master/screenshot/00.png)&nbsp;&nbsp;&nbsp;
![second img](http://github.com/dalang/fsPhoneLite/raw/master/screenshot/01.png)


![third img](http://github.com/dalang/fsPhoneLite/raw/master/screenshot/02.png)

