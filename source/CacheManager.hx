import haxe.io.Path;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.xml.Access;
import lime.utils.Assets;
#if cpp
import sys.FileSystem;
#end
class CacheManager
{
    public static var manager:CacheManager;

    // so it doesn't brick your computer lol!
    public var cachedGraphics:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	var music = [];
    var sounds = [];

    public var sharedGraphics:Map<String, String> = new Map<String, String>();
 
    public var amountLoaded = 0;
	var loadedImages = 0;
    public var state:Float = 0;
	var imageState:Float = 0;
    public var loaded = false;
	public var isfileLoad = false;

    function new()
	{
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
            if(StringTools.endsWith(i, "txt")) continue;

			music.push(i);
		}
        
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/sounds")))
        {
            sounds.push(i);
        }
	}

    public static function FilesDump()
    {
        manager = new CacheManager();

		manager.loadMusic();
		manager.loadSounds();
        
		if (FlxG.save.data.cacheImages)
		{
			manager.loadMegaImages();

		}
    }

    //Gets a specific file from the cachedGraphics
    public function get(id:String)
    {
        return cachedGraphics.get(id);
    }

    //Loads the select number of files required and persist them in the app's cache
    public function load(id:String, path:String, library:String)
    {
        var graph = FlxGraphic.fromAssetKey(Std.string(Paths.image(path, library)));
        graph.persist = true;
        graph.destroyOnNoUse = false;
        cachedGraphics.set(id,graph);
    }

    //Loads all the music files gathered from the MusicGrab() function
	public function loadMusic()
        {
            sys.thread.Thread.create(() -> {
                for (i in music)
                {
                    var inst = Paths.inst(i);
                    if (Paths.doesSoundAssetExist(inst))
                    {
                        FlxG.sound.cache(inst);
                    }
        
                    var voices = Paths.voices(i);
                    if (Paths.doesSoundAssetExist(voices))
                    {
                        FlxG.sound.cache(voices);
                    }
    
                    trace(Paths.inst(i));
                    trace(Paths.voices(i));
    
                    updateProgress();
                    updateImageProgress();
                }
    
                if (imageState == 100)
                {
                    onAssetsLoaded();
                }
            });
        }

    //Loads all the sound files gathered from the MusicGrab() function    
    public function loadSounds() {
        sys.thread.Thread.create(() -> {
            for (i in sounds)
            {
                FlxG.sound.cache(Std.string(Paths.sound(new Path(i).file, 'shared')));
                updateProgress();
                updateImageProgress();
            }
    
            if (imageState == 100)
            {
                onAssetsLoaded();
            }
        });
    }
    
    public function loadMegaImages()    
    {
        //Shared files
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
        {
            sharedGraphics.set("shared_" + i, i);
            trace(i);
        }
        
        sys.thread.Thread.create(() -> {
            for(i in sharedGraphics.keys())
            {
                load(i, sharedGraphics.get(i), 'shared');
                updateProgress();
				updateImageProgress();
            }

            if (imageState == 100)
            {
                onAssetsLoaded();
            }
        });
    }
    
    public function LastVerification()
    {
        trace("Caching Ended!");
        updateProgress();
        
    }

    public function onAssetsLoaded()
    {
        if(loaded) return;
    
        if (FlxG.save.data.cacheCutscenes)
        {
            LastVerification();
        }
    
        loaded = true;
    }


    public function updateProgress()
    {
        amountLoaded++;
        state = MathFunctions.truncateFloat(amountLoaded / (Lambda.count(sharedGraphics) + music.length + sounds.length + (FlxG.save.data.cacheCutscenes ? 8 : 0)) * 100, 2);
    }
    
    // Sprite caching relies on images being cached first. Also needs to include music
    public function updateImageProgress()
    {
        loadedImages++;
        imageState = MathFunctions.truncateFloat(loadedImages / (Lambda.count(sharedGraphics) + music.length + sounds.length) * 100, 2);
    }
    

}



