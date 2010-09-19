package com.appdao.android.feedback;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;
import android.webkit.WebView;

/*
    <p>In-app-feedback allows you to embed a comment system in your app, user could give feedback without leaving your app, you could also manage && reply easily.</p>
    
    <p>For more information, please access http://appdao.com or Email to support@appdao.com</p>
    <p>Test Account of http://appdao.com: androidtester@appdao.com    Password:000000</p>
    
*/    

public class FeedBack extends Activity {

	private static final String tag = "feedback";

	/**
	 * Prefix of Feedback URL
	 */
	private String url = "http://appdao.com/?r=feedback/home";

	/**
	 * app_name<br>
     * It may throw NameNotFoundException
	 * 
	 */
	private String app_name = "FeedBack_A";

	/**
	 * Get the package name as App Identifier<br>
	 */
	private String appid = "com.appdao.feedback";

	/**
	 * App Version
	*/
	private String version = "1.0";

	/**
	 * OS Language
	 */
	private String os_lang = "";

	/**
	 * Device ID <br>
     * Use this paramater to identify the same users who give different feedbacks<br>
     * Need to add a permission to access the Mobile status in AndroidManifest.xml<br>
     * <uses-permission android:name="android.permission.READ_PHONE_STATE"/><br>
	*/
	private String deviceid = "";

	/**
	 * Developer Key 
     * After registering on http://appdao.com, you will get a developer key for all your apps.
     * Test Account:androidtester@appdao.com    Password:000000
	 */
	private static final String key = "na5zkfz93ly4tcjmegint38gv9swtkim";

	/**
	 * User Agent 
     * You may need these information to show the status of the users who giving feedback.
     * Format:  App Name/App version (Android System version; Mobile Type SDK Version; deviceid; Display width x height; OS Language)<br>
	 * Example 1: FeedBackDemo/1.0 (Android 1.5; HTC Magic 3; 354059023764614; 320x480; en)
	 * Example 2: FeedBackDemo/1.0 (Android 2.2; Nexus One 8; 354957030973393; 320x533; zh)
	 */
	private String agent;

	/**
	 * OS Information
     * You may need this information to count the users of App
     * Format: Mobile Type_SDK Version_Android Version
     * Example 1: HTC Magic_3_1.5
     * Example 2: Nexus One_8_2.2
	 * 
	 * @see android.os.Build.MODEL
	 * @see android.os.Build.VERSION.SDK
	 * @see android.os.Build.VERSION.RELEASE
	 * 
	 */
	private String os;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.feedback);
		WebView feedbackview = (WebView) findViewById(R.id.feedbackview);
        //Enable the JavaScript to show the button and data of feedback page
		feedbackview.getSettings().setJavaScriptEnabled(true);

		initParameter();

		feedbackview.loadUrl(addUrl());
	}

	/**
	 * Add parameters of the Feedback URL
	 * The complete URL Example: http://appdao.com/?r=feedback/home&app=FeedBackDemo&appid=com.appdao.android.feedback&v=1.0&lang=en&deviceid=888&key=na5zkfz93ly4tcjmegint38gv9swtkim&agent=FeedBackDemo/1.0 (Android 1.5; HTC Magic 3; 354059023764614; 320x480; en)&os=HTC Magic_3_1.5
	 * 
	 */
	private String addUrl() {
		StringBuffer sUrl = new StringBuffer(url);
		sUrl.append("&app=").append(app_name);
		sUrl.append("&appid=").append(appid);
		sUrl.append("&v=").append(version);
		sUrl.append("&lang=").append(os_lang);
		sUrl.append("&deviceid=").append(deviceid);
		sUrl.append("&key=").append(key);
		sUrl.append("&agent=").append(agent);
		sUrl.append("&os=").append(os);

		Log.i(tag, "feedback url:" + sUrl.toString());

		return sUrl.toString();
	}

	/**
	 * init some parameters
	 */
	private void initParameter() {

		// Get app_name
		app_name = getText(R.string.app_name).toString();

		try {
			// Get package name
			appid = getPackageName();

			PackageInfo info = getPackageManager().getPackageInfo(appid, 0);
            
			// Get App Version
			version = info.versionName;

		} catch (NameNotFoundException e) {
			Log.i(tag, e.getMessage());
		}

		// Get OS Language
		os_lang = java.util.Locale.getDefault().getLanguage();

		// Get deviceid
		TelephonyManager mTelephonyMgr = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
		deviceid = mTelephonyMgr.getDeviceId();

        //Get User Agent
		agent = createAgent();

		// Get OS
		os = android.os.Build.MODEL + "_" + android.os.Build.VERSION.SDK + "_"
				+ android.os.Build.VERSION.RELEASE;

	}

	private String createAgent() {
		// Get Display Manage Service
		WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
		// Get Width and Height of Display
		Display d = wm.getDefaultDisplay();
		int dh = d.getHeight();
		int dw = d.getWidth();
		StringBuffer sb = new StringBuffer();
		sb.append(app_name).append("/").append(version);
		sb.append(" (");
		sb.append("Android").append(" ");
		sb.append(android.os.Build.VERSION.RELEASE).append("; ");
		sb.append(android.os.Build.MODEL).append(" ")
				.append(android.os.Build.VERSION.SDK).append("; ");
		sb.append(deviceid).append("; ");
		sb.append(dw).append("x").append(dh).append("; ");
		sb.append(os_lang).append(")");
		return sb.toString();
	}

}