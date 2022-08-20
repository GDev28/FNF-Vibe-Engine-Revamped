package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.graphics.FlxGraphic;

using StringTools;

class AppInit extends MusicBeatState
{
		var loadingBG:FlxSprite;
		var completed:Bool = false;
		var done:Float = 1;
		var bar:FlxBar;
		var barProgress:Float = 0;

		var loaded = false;

		var text:FlxText;

		public static var bitmapData:Map<String, FlxGraphic>;

		override function create()
		{
			FlxG.worldBounds.set(0,0);

			PlayerSettings.init();

			//Do when i have the images in their places
			/*
			loadingBG = new FlxSprite(0, 0).loadGraphic(Paths.image('Funkin', 'art'));
			loadingBG.setGraphicSize(FlxG.width, FlxG.height);
			loadingBG.updateHitbox();
			/*Need to add clientSettings
			loadingBG.antialiasing = ClientSettings.globalAntialiasing;
			add(loadingBG);
			loadingBG.scrollFactor.set();
			loadingBG.screenCenter();
			*/


			text = new FlxText(FlxG.width - 250, FlxG.height - 250, 0, "Loading...");
			text.setFormat("VCR OSD Mono", 34, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.alignment = FlxTextAlign.CENTER;
			text.screenCenter(X);
			add(text);

			var blackbar = new FlxSprite(0,0).makeGraphic(FlxG.width,350,FlxColor.BLACK);
			blackbar.alpha = 0.350;
			add(blackbar);

			CacheManager.FilesDump();
			updateLoadingText();


		}
		override function update(elapsed:Float)
			{
				if (!CacheManager.manager.loaded)
					done = CacheManager.manager.state;
				else
				{
					// Set it to loaded
					if (done != 100)
					{
						done = 100;
						text.text = "Press Enter to continue";
						text.screenCenter(X);
						completed = true;
					}

					if(completed && (FlxG.keys.justPressed.ENTER || controls.ACCEPT)){
						FlxG.switchState(new TitleState());
					}

					if(FlxG.keys.justPressed.R){
						FlxG.switchState(new AppInit());
					}
		
					
				}
				bar.value = done;
		
				super.update(elapsed);
			}
		
		function updateLoadingText()
		{
			if (done != 100)
			{
				trace(done);
				text.text = "Loading (" + done + "%/100%)";
				text.setFormat("VCR OSD Mono", 34, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				text.screenCenter(X);
				new FlxTimer().start(0.1, function(tmr:FlxTimer){ updateLoadingText(); });
			}
		}	
}

