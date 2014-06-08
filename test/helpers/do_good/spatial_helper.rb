module DoGood::SpatialHelper
  MIDDLE_OF_TORONTO =
    "SRID=4326; POINT (-79.3901881618097889 43.7266091633893410)".freeze

  MIDDLE_OF_TORONTO_QUAD_TREE =
    "0302231312023033013303".freeze

  BOUNDS_FOR_TORONTO =
    "SRID=4326; POLYGON ((-79.6392189999996702 43.5810858865227075, -79.1158320912574595 43.5810858865227075, -79.1158320912574595 43.8554580000001835, -79.6392189999996702 43.8554580000001835, -79.6392189999996702 43.5810858865227075))".freeze

  URL_VALUE_BOUNDS_FOR_TORONTO =
    "43.581086,-79.639219,43.855458,-79.115832".freeze

  BOUNDARY_FOR_HIGH_PARK_TORONTO = <<-GEOM.freeze
    SRID=4326; POLYGON ((
      -79.46467 43.63543, -79.46893 43.64013, -79.47080 43.64225,
      -79.47099 43.64248, -79.47106 43.64256, -79.47110 43.64262,
      -79.47115 43.64269, -79.47626 43.65113, -79.47941 43.65863,
      -79.47967 43.65924, -79.47972 43.65937, -79.48000 43.66005,
      -79.48214 43.66557, -79.48064 43.66557, -79.47890 43.66555,
      -79.47324 43.66551, -79.46325 43.66539, -79.46227 43.66537,
      -79.46203 43.66536, -79.46185 43.66534, -79.46172 43.66532,
      -79.46162 43.66530, -79.46148 43.66527, -79.45917 43.66467,
      -79.45862 43.66453, -79.45804 43.66435, -79.45797 43.66432,
      -79.45790 43.66429, -79.45781 43.66423, -79.45774 43.66418,
      -79.45732 43.66381, -79.45655 43.66310, -79.45649 43.66304,
      -79.45582 43.66237, -79.45424 43.66074, -79.45395 43.66045,
      -79.45389 43.66037, -79.45383 43.66029, -79.45378 43.66019,
      -79.45367 43.65992, -79.45303 43.65842, -79.45297 43.65829,
      -79.44610 43.63873, -79.44629 43.63864, -79.45095 43.63654,
      -79.46467 43.63543
    ))
  GEOM

  MIDDLE_OF_MISSISSAUGA =
     "SRID=4326; POINT (-79.6615757563317004 43.5997598811829548)".freeze

  BOUNDS_FOR_MISSISSAUGA =
    "SRID=4326; POLYGON ((-79.8083069999996724 43.4809897105576155, -79.5408499816613670 43.4809897105576155, -79.5408499816613670 43.7373510000001460, -79.8083069999996724 43.7373510000001460, -79.8083069999996724 43.4809897105576155))".freeze

  MIDDLE_OF_VANCOUVER =
    "SRID=4326; POINT (-123.1226704070656695 49.2496590870085171)".freeze

  BOUNDS_FOR_VANCOUVER =
    "SRID=4326; POLYGON ((-123.2648879368376242 49.1996155702865252, -123.0230679999997108 49.1996155702865252, -123.0230679999997108 49.3142378325417994, -123.2648879368376242 49.3142378325417994, -123.2648879368376242 49.1996155702865252))".freeze

  MIDDLE_OF_NOWHERE_IN_NUNAVUT =
    "SRID=4326; POINT (-106.997815 -5.053614)".freeze

  MIDDLE_OF_NOWHERE_IN_NUNAVUT_QUAD_TREE =
    "20110033311230031030230".freeze

  MIDDLE_OF_ST_PETERS_NS =
    "SRID=4326; POINT (-60.87507 45.656034)".freeze

  BOUNDS_FOR_ST_PETERS_NS =
    "SRID=4326; POLYGON ((-60.8910774 45.6482344, -60.8590626 45.6482344, -60.8590626 45.6638325, -60.8910774 45.6638325, -60.8910774 45.6482344))".freeze
end

