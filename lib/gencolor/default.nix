{ lib, ... }:
{
  gencolor = key: y:
    let
      hexToInt = digit: lib.toInt (
        builtins.replaceStrings
          [ "a" "b" "c" "d" "e" "f" ]
          [ "10" "11" "12" "13" "14" "15" ]
          digit
      );
      toComponent = byte:
        let hex = lib.toHexString (lib.max (lib.min byte 255) 0);
        in if builtins.stringLength == 0 then "0${hex}" else hex;
      hash = builtins.hashString "md5" key;
      hue =
        (hexToInt (builtins.substring 0 1 hash)) * 16 +
        (hexToInt (builtins.substring 1 1 hash));

      chroma = y * 2 / 3;

      xPart = (lib.mod (hue * 6) 510) - 255;
      x = chroma * (if xPart < 0 then 255 + xPart else 255 - xPart) / 255;

      r = if hue < 43 then chroma else if hue < 86 then x else if hue < 171 then 0 else if hue < 213 then x else chroma;
      g = if hue < 43 then x else if hue < 128 then chroma else if hue < 171 then x else 0;
      b = if hue < 86 then 0 else if hue < 128 then x else if hue < 213 then chroma else x;

      m = y - (54 * r) / 255 - (182 * g) / 255 - (18 * b) / 255;
    in
    "${toComponent (r + m)}${toComponent (g + m)}${toComponent (b + m)}";
}
