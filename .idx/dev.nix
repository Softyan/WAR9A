{ pkgs }: {
  channel = "stable-23.11";
  packages = [
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
    pkgs.unzip
  ];
  idx.extensions = [

  ];
  idx.previews = {
    previews = {
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "emulator-5554"
        ];
        manager = "flutter";
      };
      # ios = {
      #   command = [
      #     "flutter"
      #     "run"
      #     "--machine"
      #     "-d"
      #     "iPhone 14 Pro Max" # Or any other available iOS simulator 
      #   ];
      #   manager = "flutter";
      # };
      # android_sdk34 = {
      #   command = [
      #     "flutter"
      #     "run"
      #     "--machine"
      #     "-d"
      #     "pixel_2_api_34" # Replace with the correct emulator ID for Pixel 2 API 34
      #   ];
      #   manager = "flutter";
      # };
      # android_sdk32 = {
      #   command = [
      #     "flutter"
      #     "run"
      #     "--machine"
      #     "-d"
      #     "pixel_2_api_32" # Replace with the correct emulator ID for Pixel 2 API 32
      #   ];
      #   manager = "flutter";
      # };
    };
  };
}
