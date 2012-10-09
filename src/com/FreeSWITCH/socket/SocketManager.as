package com.FreeSWITCH.socket
{
	import com.FreeSWITCH.XML.ESL_event;
	
	import flash.events.*;
	import flash.system.Security;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import events.*;
	
	public class SocketManager
	{
		[Bindable]
		public  var esl:ESL = null;

		private var socketServer:String; 
		private var socketPort:String;
		private var socketPwd:String;
		private var sipRealm:String;

		[Bindable]
		public var myRtmpDialstr:String;
		public var connectTmr:Timer;
		public var reConnectTmr:Timer;
													
		public function SocketManager(socketServer:String, socketPort:String, socketPwd:String, sipRealm:String)
		{
			this.socketServer = socketServer;
			this.socketPwd = socketPwd;
			this.socketPort = socketPort;
			this.sipRealm = sipRealm;
		
			this.init()
		}

		private function init():void
		{
			esl = new ESL(this.socketPwd);
			connectTmr = new Timer(2000);
			reConnectTmr = new Timer(2000);
			connectTmr.addEventListener(TimerEvent.TIMER, postConnect);
			reConnectTmr.addEventListener(TimerEvent.TIMER, reConnect);
		}

		public function closeSocket():void
		{
			esl.close();
			reConnectTmr.stop();
			connectTmr.stop();
		}

		public function postConnect(event:TimerEvent):void
		{
			event.target.stop();

			if (!esl.connected)
			{
				reConnectTmr.start();
				return;
			}

			msg("event plain CUSTOM|conference::maintenance");
			esl.esl_event("CUSTOM conference::maintenance", "plain", cmdCallback);
		}

		public function cmdCallback(data:String):void
		{
			msg(data);
		}

		public function reConnect(event:TimerEvent):void
		{
			event.target.stop();
			event.target.delay += 2000;

			// give up setting up the esl connection if the threshold is exceeded
			if (event.target.delay > 10000)
			{
				connectTmr.stop();
			}

			msg("Connect faild. will reconnect in " + event.target.delay + " seconds");
			eslConnect();
		}

		/******************************** Event Socket Fucntions ***************************************/
		public function eslConnect():void
		{
			try
			{
				connectTmr.start();
				if (esl.connected)
				{
					msg("Already Connected");
					return;
				}

				Security.loadPolicyFile("xmlsocket://" + this.socketServer + ":" + this.socketPort);

				esl.setauthCallback(authCallback);
				esl.connect(this.socketServer, (int)(this.socketPort));
				esl.addEventListener(Event.CONNECT, connectHandler);
				esl.addEventListener(Event.CLOSE, closeHandler);
				esl.addEventListener(ErrorEvent.ERROR, errorHandler);
				esl.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				esl.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				esl.addEventCallback("CUSTOM|conference::maintenance", onConferenceEvent);
			}

			catch (error:Error)
			{
				msg(error.message);
				esl.close();
			}
		}

		public function connectHandler(event:Event):void
		{
			setSocketStatus('Connected');
			msg("ESL Connected: " + this.socketServer + ":" + this.socketPort);
		}

		public function closeHandler(event:Event):void
		{
			msg(event.type + ' ' + event.toString());
			setSocketStatus('Disconnected');
		}

		public function errorHandler(event:Event):void
		{
			msg(event.type + ' ' + event.toString());
			setSocketStatus('Error');
		}

		public function ioErrorHandler(event:IOErrorEvent):void
		{
			msg(event.type + ' ' + event.toString());
			setSocketStatus('IOError');

			if (!esl.connected)
			{
				eslConnect();
			}
		}

		public function securityErrorHandler(event:SecurityErrorEvent):void
		{
			msg(event.type + ' ' + event.toString());
			setSocketStatus('SecurityError');

			if (!esl.connected)
			{
				eslConnect();
			}

		}

		public function rtmpContactCallback(data:String):void
		{
			msg(data);
			if (data.substr(0, 5) == "rtmp/")
			{
				myRtmpDialstr = data;
			}
			else
			{
				myRtmpDialstr = "";
			}
		}

		/************************ Conference Info Functions ****************************/
		public function sendConferenceListCmd(conferenceid:String):void
		{
			var cmd:String = "conference ";
			cmd += conferenceid + "-" + sipRealm + " list";

			esl.api(cmd, conferencelistCallback);
		}

		public function dialRtmpClient(dialstr:String, group_id:String):void
		{
			if (group_id != '')
			{
				esl.bgapi("conference " + group_id + "-" + sipRealm + " dial {group=" + group_id + "}" + dialstr + " groupcall " + group_id);
			}
		}

		public function getRtmpDialstr(username:String, sipRealm:String, profile:String = "default"):void
		{
			esl.api("rtmp_contact " + profile + "/" + username + '@' + sipRealm, rtmpContactCallback);
		}

		public function authCallback(data:String):void
		{
			if (data.substr(0, 12) == "+OK accepted")
			{
				dispatchEvent(new SocketMessageEvent(SocketMessageEvent.MESSAGE, SocketMessageEvent.ESLCMD, "auth"));
			}
		}

		public function conferencelistCallback(data:String):void
		{
			if (data == "No active conferences.")
				return;
			dispatchEvent(new SocketMessageEvent(SocketMessageEvent.MESSAGE, SocketMessageEvent.ESLCMD, "conference specific list", null, data));
		}

		public function onConferenceEvent(eslev:ESL_event):void
		{
			// update conference info
			dispatchEvent(new SocketMessageEvent(SocketMessageEvent.MESSAGE, SocketMessageEvent.ESLCONFERENCEEVENT, "Conference", eslev));
		}

		private function setSocketStatus(status:String):void
		{
			dispatchEvent(new SocketMessageEvent(SocketMessageEvent.MESSAGE, SocketMessageEvent.ESLSTAUS, status));
		}

		private function msg(message:String):void
		{
			dispatchEvent(new LogMessageEvent(LogMessageEvent.LOG, LogMessageEvent.ESLLOG, message));
		}
	}
}