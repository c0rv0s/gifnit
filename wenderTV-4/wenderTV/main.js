/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

var resourceLoader;


App.onLaunch = function(options) {
  // 1:
  evaluateScripts(options.initialJSDependencies,
    function(success) {
      if (success) {
        // 2:
        resourceLoader =
          new ResourceLoaderJS(NativeResourceLoader.create());
        var initialDoc = loadInitialDocument(resourceLoader);
        initialDoc.addEventListener("select", _handleEvent);
        navigationDocument.pushDocument(initialDoc);
      } else {
        // 3:
        var alert = _createAlert("Evaluate Scripts Error",
          "Error attempting to evaluate the external JS files.");
        navigationDocument.presentModal(alert);
   
        throw ("Playback Example: unable to evaluate scripts.");
      }
    });
};


function loadInitialDocument(resourceLoader) {
  var data = resourceLoader.getJSON("identity.json");
  data["images"] = resourceLoader
    .convertNamesToURLs(data["images"]);
  data = resourceLoader
    .recursivelyConvertFieldsToURLs(data, "image");
  data["sharedImages"] = _sharedImageResources(resourceLoader);
  return resourceLoader.getDocument("video.tvml", data);
}

function _sharedImageResources(resourceLoader) {
  var sharedImageNames = {
    heads: "heads.png",
    face: "face.png",
    rock: "rock.png",
    background: "tv_background.png"
  };

  return resourceLoader.convertNamesToURLs(sharedImageNames);
}

function _createAlert(title, description) {  
  var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
    <document>
      <alertTemplate>
//        <title>${title}</title>
        <description>${description}</description>
    <rainbowText style="font-size: 29;">Welcome to tvOS!</rainbowText>
    <rainbowProgress id="rainbowProgress" progress="0.55" style="margin: 20;
      </alertTemplate>
    </document>`

  var parser = new DOMParser();
  var alertDoc = parser.parseFromString(alertString, "application/xml");
  return alertDoc
}

function _handleEvent(event) {
  // 1:
  var sender = event.target;
  var action = sender.getAttribute("action");
  // 2:
  switch(action) {
    case "showOverflow":
      // 3:
      var data = {
        text: sender.textContent,
//        title: sender.getAttribute("title")
      };
      // 4:
      var expandedText = resourceLoader
        .getDocument("expandedDetailText.tvml", data);
      expandedText.addEventListener("select", _handleEvent);
      navigationDocument.presentModal(expandedText);
      break;
    case "dismiss":
      // 5:
      navigationDocument.dismissModal();
      break;
  }
}
