package org.un.crossfading;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        menu.add("Go").setShowAsActionFlags(MenuItem.SHOW_AS_ACTION_IF_ROOM).setOnMenuItemClickListener((MenuItem item) -> {
            item.setEnabled(false);

            View hello = findViewById(R.id.hello);
            View world = findViewById(R.id.world);

            hello.animate().alpha(1 - hello.getAlpha()).setDuration(1000);
            world.animate().alpha(1 - world.getAlpha()).setDuration(1000).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    item.setEnabled(true);
                }
            });

            return true;
        });
        return super.onCreateOptionsMenu(menu);
    }
}
