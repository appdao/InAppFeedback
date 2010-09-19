package com.appdao.android.feedback;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

public class MainActivity extends Activity implements OnClickListener {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mian);

		findViewById(R.id.feedback).setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.feedback:
			//Open the Feedback Page
			Intent i = new Intent(this, FeedBack.class);
			startActivity(i);
			break;

		default:
			break;
		}
	}

}
