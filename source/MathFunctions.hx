import flixel.FlxG;
import flixel.math.FlxMath;

class MathFunctions
{
	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	public static function GCD(a, b)
	{
		return b == 0 ? FlxMath.absInt(a) : GCD(b, a % b);
	}

    //I don't need this shit lol
	/*public static function CreditsPostion(x:Float){
		return -0.002 * Math.pow(x, 2) + 1.256 * x;
	}*/
}