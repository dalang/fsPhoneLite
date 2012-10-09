// ActionScript file
package com.FreeSWITCH.rtmp
{
	import com.adobe.crypto.MD5;

	import flash.events.*;
	import flash.external.*;
	import flash.media.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import events.*;

	public class RTMP
	{
		[Bindable]
		public var netConnection:NetConnection = null;
		private var incomingNetStream:NetStream = null;
		private var outgoingNetStream:NetStream = null;
		private var mic:Microphone = null;
		[Bindable]
		private var microphoneList:Array;
		private var sessionID:String;
		private var authUser:String;
		private var authDomain:String;
		private var attachedUUID:String = null;

		public var uuid:String;
		private var username:String;
		private var password:String;
		private var sipRealm:String;
		private var sipServer:String;
		private var rtmp_url:String = "rtmp://127.0.0.1/phone";

		private var isConnected:Boolean = false;

		public function RTMP(username:String, password:String, realm:String, server:String)
		{
			trace("initial a new rtmp object");
			this.username = username;
			this.password = password;
			this.sipRealm = realm;
			this.sipServer = server;

			setRtmpUrl(sipServer);
			init();
		}

		public function setRtmpUrl(fs_addr:String):void
		{
			rtmp_url = 'rtmp://' + fs_addr + '/phone';
		}

		public function getUser():String
		{
			return username;
		}

		/********* fsPhone functions **********/
		public function doCallChar(chr:String):void
		{
			sendDTMF(chr, 2000);
		}

		public function doCall(dialStr:String):void
		{
			var destination:String = "sip:" + dialStr + "@" + sipRealm;
			var rtmp_username:String = username + '@' + sipRealm;
			makeCall(destination, rtmp_username, [])
		}

		public function doHangUp():void
		{
			hangup();
			if (isConnected)
			{
				isConnected = false;
			}
		}

		public function doAccept(callerUuid:String):void
		{
			answer(callerUuid);
		}

		public function doTransfer(transferTo:String):void
		{
			if (transferTo != username)
				transfer(this.uuid, transferTo);
		}

		public function doStreamStatus(status:String):void
		{
			//netConnection.call("streamStatus", null, uid, status);	
		}

		public function doHold(action:String):void
		{
			if (action == "Hold")
				attach('');
			else
				attach(uuid);
		}

		/********* JavaScript functions *********/
		public function sendDTMF(digits:String, duration:int):void
		{
			if (netConnection != null)
			{
				netConnection.call("sendDTMF", null, digits, duration);
			}
		}

		public function makeCall(number:String, account:String, evt:Object):void
		{
			if (netConnection != null)
			{
				netConnection.call("makeCall", null, number, account, evt);
			}
		}

		public function showPrivacy():void
		{
			Security.showSettings(SecurityPanel.PRIVACY);
		}

		public function login():void
		{
			var rtmp_username:String = username + '@' + sipRealm;
			if (netConnection != null)
			{
				netConnection.call("login", null, rtmp_username, MD5.hash(sessionID + ":" + rtmp_username + ":" + this.password));
			}
		}

		public function logout(account:String):void
		{
			if (netConnection != null)
			{
				netConnection.call("logout", null, account);
			}
		}

		public function hangup():void
		{
			if (uuid == attachedUUID)
			{
				destroyStreams();
			}
			if (netConnection != null)
			{
				netConnection.call("hangup", null, uuid);
			}
		}

		public function answer(uuid:String):void
		{
			if (incomingNetStream == null)
			{
				setupStreams();
			}
			if (netConnection != null)
			{
				netConnection.call("answer", null, uuid);
			}
		}

		public function record(actionType:String):void
		{
			if (netConnection != null && this.uuid != "")
			{
				netConnection.call("record_session", null, this.uuid, actionType);
			}
		}


		public function attach(uuid:String):void
		{
			if (netConnection != null)
			{
				netConnection.call("attach", null, uuid);
			}
		}

		public function transfer(uuid:String, number:String):void
		{
			if (netConnection != null)
			{
				netConnection.call("transfer", null, uuid, number);
			}
		}

		public function ptt(group_id:String, sip_account:String, action_type:String):void
		{
			if (null == sip_account)
				sip_account = username;

			if (netConnection != null)
			{
				netConnection.call("ptt", null, group_id, sip_account, action_type);
			}
		}

		public function groupcall(group_id:String, originator:String, str_members:Array, action:String):void
		{
			if (action == ResourceUtil.getInstance().getString('phoneCanvas.groupcallon'))
			{
				// Get group call's members
				var arr_mems:Array = str_members;
				var dialstr:String;

				for (var i:int = 0; i < arr_mems.length; i++)
				{
					trace(arr_mems[i]);
					// destination number is from rtmp
					if (int(arr_mems[i]) >= 1100 && int(arr_mems[i]) <= 1199)
					{
						dialstr = "rtmp/default/" + arr_mems[i] + '@' + sipRealm;
						if (originator == arr_mems[i])
							netConnection.call("makePttcall", null, group_id, dialstr, false);
						else
							netConnection.call("makePttcall", null, group_id, dialstr, true);
					}
					// destination number is from sofia 
					else
					{
						dialstr = "user/" + arr_mems[i];
						netConnection.call("makePttcall", null, group_id, dialstr, true);
					}
				}

				dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.CALLSTATE, 'HupCall'));
			}
			else
			{

				netConnection.call("hupPttcall", null, "normal_clearing", group_id);
			}
		}

		public function pttdialOwnClient(group_id:String):void
		{
			var dialstr:String = "rtmp/default/" + username + '@' + sipRealm;
			if (group_id != '')
				netConnection.call("makePttcall", null, group_id, dialstr, false);
		}

		public function register(account:String, nickname:String):void
		{
			if (netConnection != null)
			{
				netConnection.call("register", null, account, nickname);
			}
		}


		/********* FreeSWITCH functions *********/
		/* XXX: TODO: Move those in a separate object so a malicious server can't setup streams and spy on the user */
		public function displayUpdate(uuid:String, name:String, number:String):void
		{
		}

		public function connected(sid:String):void
		{
			sessionID = sid;
			onDebug("rtmp is on connected with session: " + sessionID);
			dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.NETSTAUS, 'Connection success'));
		}

		public function onLogin(result:String, user:String, domain:String):void
		{
			if (result == "success")
			{
				onDebug("login success.");
				register(user + '@' + domain, "");
				dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.SIP_Login, "SUCCESS"));
			}
			else if (result)
			{
				onDebug("login failed!");
				dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.SIP_Login, result));
			}

		}

		public function onRegister(result:String, user:String, domain:String):void
		{
			if (result == "success")
			{
				onDebug("register success.");
				dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.SIP_REGISTER, "SUCCESS"));
			}
			else if (result)
			{
				onDebug("register failed!");
				dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.SIP_REGISTER, result));
			}

		}

		public function incomingCall(uuid:String, name:String, number:String, account:String, evt:Object):void
		{
			this.uuid = uuid;
			if (evt != null)
			{
				if (evt.hasOwnProperty("rtmp_auto_answer"))
				{
					if (evt.rtmp_auto_answer == "true")
					{
						answer(uuid);
					}
				}
			}

			dispatchEvent(new IncomingCallEvent(IncomingCallEvent.INCOMING, uuid, name, number, account));
		}

		public function onAttach(uuid:String):void
		{
			attachedUUID = uuid;
			// TODO need to test more
			if (attachedUUID == "")
			{
				//destroyStreams();
			}
			else if (incomingNetStream == null || outgoingNetStream == null)
			{
				setupStreams();
			}
		}

		public function onMakeCall(uuid:String, number:String, account:String):void
		{
			onDebug("uuid " + uuid + " has been setup.");
			this.uuid = uuid;
		}

		public function callState(uuid:String, state:String):void
		{
			var msg:String = "";
			onDebug("onCallState uuid " + uuid + " state " + state);

			if (state == "HANGUP")
				msg = "onUaCallClosed";

			dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.CALLSTATE, msg));

			if (msg == "onUaCallClosed" || msg == "onUaCallFailed" || msg == "onUaCallTrasferred")
			{
				dispatchEvent(new CallDisconnectedEvent(CallDisconnectedEvent.DISCONNECTED, msg));
				isConnected = false;
			}
			//missed call
			if (msg == "onUaCallCancelled")
			{
				dispatchEvent(new MissedCallEvent(MissedCallEvent.CALLMISSED, msg));
				isConnected = false;
			}
		}

		public function onHangup(uuid:String, cause:String):void
		{
			onDebug("onHangup uuid " + uuid + " cause " + cause);
			var msg:String = "";
			if (cause == "ORIGINATOR_CANCEL")
			{
				msg = "onUaCallCancelled";
				dispatchEvent(new MissedCallEvent(MissedCallEvent.CALLMISSED, msg));
				isConnected = false;
			}
			else if (cause == "MANAGER_REQUEST")
			{
				msg = "onGroupCallClosed";
				destroyStreams(msg);
				isConnected = false;
			}

			dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.CALLSTATE, 'GroupcallHangup'));
		}

		public function onPTT(uuid:String, group_ide:String, sip_accounte:String, action_type:String, status:Boolean):void
		{
			if (status == true)
			{
				onDebug("ptt " + action_type + " failed.");
				return;
			}
			else
				onDebug("ptt " + action_type + " successed.");
		}

		public function onRecord(uuid:String, file:String, action_type:String, status:Boolean):void
		{
			if (status == true)
			{
				onDebug("record " + action_type + " failed.");
				return;
			}

			if (action_type == "on")
			{
				onDebug("Start Recording...");
			}
			else // off
			{
				onDebug(uuid + file + action_type);
				onDebug("Stop Recording, your Audio clip has been save as \"" + ((file != null) ? file.replace(/\\/g, '/') : "") + "\". ");
			}

			dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.RECORDSTATE, action_type));
		}

		/********* Internal functions *********/
		private function onDebug(message:String):void
		{
			trace(message);
			dispatchEvent(new LogMessageEvent(LogMessageEvent.LOG, LogMessageEvent.RTMPLOG, message));
		}

		private function init():void
		{
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			netConnection = new NetConnection();

			netConnection.client = this;
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		public function connect():void
		{
			netConnection.connect(rtmp_url);
		}

		public function disconnect():void
		{
			if (netConnection != null)
			{
				netConnection.close();
				netConnection = null;
				incomingNetStream = null;
				outgoingNetStream = null;
			}
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			onDebug("securityErrorHandler: " + event.text);
		}

		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			onDebug("asyncErrorHandler: " + event.text);
		}

		private function activityHandler(event:ActivityEvent):void
		{
			onDebug("activityHandler: " + event);
		}

		private function statusHandler(event:StatusEvent):void
		{
			onDebug("statusHandler: " + event);
		}

		private function netStatus(evt:NetStatusEvent):void
		{

			onDebug("netStatus: " + evt.info.code);

			switch (evt.info.code)
			{

				case "NetConnection.Connect.Success":
					break;

				case "NetConnection.Connect.Failed":
					netConnection = null;
					incomingNetStream = null;
					outgoingNetStream = null;
					dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.NETSTAUS, 'Failed to connect to FreeSWITCH'));
					break;

				case "NetConnection.Connect.Closed":
					netConnection = null;
					incomingNetStream = null;
					outgoingNetStream = null;
					dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.NETSTAUS, 'Failed to connect to FreeSWITCH'));
					break;

				case "NetConnection.Connect.Rejected":
					netConnection = null;
					incomingNetStream = null;
					outgoingNetStream = null;
					dispatchEvent(new RtmpMessageEvent(RtmpMessageEvent.MESSAGE, RtmpMessageEvent.NETSTAUS, 'Connection Rejected'));
					break;

				case "NetStream.Play.StreamNotFound":
					break;

				case "NetStream.Play.Failed":
					break;

				case "NetStream.Play.Start":
					break;

				case "NetStream.Play.Stop":
					break;

				case "NetStream.Buffer.Full":
					break;

				default:
			}
		}

		private function destroyStreams(msg:String = "onUaCallClosed"):void
		{
			if (msg == "onUaCallClosed" || msg == "onUaCallFailed" || msg == "onUaCallTrasferred" || msg == "onGroupCallClosed")
			{
				dispatchEvent(new CallDisconnectedEvent(CallDisconnectedEvent.DISCONNECTED, msg));
				isConnected = false;
			}
		}

		private function setupStreams():void
		{
			onDebug("Setup media streams");
			var publishName:String = "publish";
			var playName:String = "play";
			dispatchEvent(new CallConnectedEvent(CallConnectedEvent.CONNECTED, publishName, playName));
			isConnected = true;
		}

	}
}
