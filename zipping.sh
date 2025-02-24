FUNCTIONS=("create" "delete" "id" "list" "mail" "update")
BUILD_PATH="module/code/zip"

mkdir -p $BUILD_PATH

for FUNCTION in "${FUNCTIONS[@]}"
do
  ROUTE_FUNCTION="$BUILD_PATH/$FUNCTION"
  echo "Zipping lambda: $FUNCTION"

  mkdir -p "$ROUTE_FUNCTION"

  cp "module/code/src/$FUNCTION.js" "$ROUTE_FUNCTION/"
  cp "module/code/package.json" "$ROUTE_FUNCTION/"
  cp -r "module/code/node_modules" "$ROUTE_FUNCTION/"

  cd "$BUILD_PATH" || exit
  zip -r "$FUNCTION.zip" "$FUNCTION"
  rm -rf "$FUNCTION"
  cd "../../../"


  echo "Created zip:  $BUILD_PATH/$FUNCTION.zip"
done