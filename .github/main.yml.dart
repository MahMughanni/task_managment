
  on:
    pull_request:
      branches:
         -main
         -master

    push:
      branches:
        -main
        -master
        -develop
  name: "Build & Release"
  jobs:
    build:
      name: Build & Release
      run-on: macos-latest
      steps:
        - uses: actions/chechout@v1
        - uses: actions/setup-java@v1
          with:
           java-version: '12.x'
        - uses: subsoito/flutter-action@v1
          with:
           flutter-version: '2.2.0'
        - run: flutter pub get
        - run: flutter test
        - run: flutter build apk --debug --spilt-pre-abi
        - name: Push to Release
          uses: ncipollo/release-action@v1
          with:
            artifacts: "build/app/outputs/apk/debug/*"
            tag: v1.0.${{ github.run_number }}
            token: ${{ secrets.TOKEN }}








