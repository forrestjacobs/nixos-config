final: prev: {
  plex =
    let plexpass-lock = final.lib.importJSON ./plexpass.json;
    in prev.plex.override {
      plexRaw = prev.plexRaw.overrideAttrs (x: {
        name = "plexmediaserver-${plexpass-lock.version}";
        src = final.fetchurl {
          url = plexpass-lock.release.url;
          sha1 = plexpass-lock.sha1;
        };
      });
    };
}
