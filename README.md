# Dribblone

An assistant that helps your dribble training of basketball.

## Features

### Post Wall

> Presenting training posts from all of the other users.

Customize `WaterfallLayout` which inherits from `UICollectionViewLayout`.
Random height is given to each collection view cell.

Play training videos by `AVPlayerViewController` in AVKit.

### Training Menu

> Selecting a mode of dribbling that you want to drill in.

![](https://github.com/nicklu717/Dribblone/blob/develop/Screen%20Shots/TrainingMenu.gif)

Enable fade-in animation for cells when scrolling the table view with `UITableViewDelegate` method:

``` Swift
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    cell.alpha = 0
    
    UIView.animate(withDuration: 0.3) {
        
        cell.alpha = 1
    }
}
```

### Instruction Page

> Provide some information about the training mode.

Embed YouTube videos with `YTPlayerView` in `youtube-ios-player-helper` library.

### Training

> Handle basketball to touch the pumping target node on the screen.<br>
> Get points as many as you can within the time limit.

![](https://github.com/nicklu717/Dribblone/blob/develop/Screen%20Shots/Training.gif)

Setup `AVCaptureSession` and embed captured image in `AVCaptureVideoPreviewLayer`:

``` Swift
let cameraLayer = AVCaptureVideoPreviewLayer()
let captureSession = AVCaptureSession()

private func setUpCaptureSession() {
        
    captureSession.sessionPreset = .high
    
    guard let camera =
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
    
    do {
        
        let cameraInput = try AVCaptureDeviceInput(device: camera)
        
        captureSession.addInput(cameraInput)
        
    } catch {
        
        print(error)
    }

    let videoDataOutput = AVCaptureVideoDataOutput()
        
    let videoDataOutputQueue = DispatchQueue.global()
    
    videoDataOutput.setSampleBufferDelegate(self.videoOutputDelegate, queue: videoDataOutputQueue)
    
    captureSession.addOutput(videoDataOutput)
}

private func setUpCameraLayer() {
    
    cameraLayer.session = captureSession
    
    cameraLayer.videoGravity = .resizeAspectFill
    
    cameraLayer.connection?.videoOrientation = .landscapeLeft
    
    layer.addSublayer(cameraLayer)
}
```

When the training starts:

1. Automatically take a screen shot by converting the `CVPixelBuffer` into `CIImage` and `UIImage`, which is intercepted from `AVCaptureVideoDataOutput`.

2. Record screen by `RPScreenRecorder`.

3. Set target node with `SpriteKit`. Node animation is composed of with a sequence of `SKTexture`:

    ``` Swift
    let pumpingTargetPointAtlas = SKTextureAtlas(named: "PumpingTargetPoint")
            
    var pumpingTextures: [SKTexture] = []

    for index in 1...pumpingTargetPointAtlas.textureNames.count {
        
        let textureName = "flash\(index)"
        
        pumpingTextures.append(pumpingTargetPointAtlas.textureNamed(textureName))
    }

    targetNode = SKSpriteNode(texture: pumpingTextures[0])

    let animation = SKAction.animate(with: pumpingTextures, timePerFrame: timePerFrame)

    targetNode.run(SKAction.repeatForever(animation))
    ```

During the training:

1.  Analyze `CMSampleBuffer` output from `AVCaptureVideoDataOutput` for basketball object and coordinate with `Vision`, which uses `MobileNetV2_SSDLite` maching learning model as `VNCoreMLModel`.

    ``` Swift
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let coreMLRequest = VNCoreMLRequest(model: coreMLModel,
                                            completionHandler: coreMLRequestCompletion(request:error:))
        
        coreMLRequest.imageCropAndScaleOption = .scaleFill
        
        do {
        
            try sequenceRequestHandler.perform([coreMLRequest], on: pixelBuffer)
        
        } catch {
        
            print(error)
        }
    }
    ```

2. Convert basketball coordinate and put a `SKShapeNode` on it. Implementing `SKPhysicsContactDelegate` method to detect the contact between basketball node and target node to give user points.

When the training ends:

1. User can choose whether to save the training video or not.

2. If user chooses to save the video, fetch the video from the album immediately and write video data to a temporary directory with `PHAssetResourceManager` for the `Firebase` uploading operation.
 
### Profile Page

> Show user's information, such as ID, following and follower's number and training history.

Embed training videos in `AVPlayerLayer`.
Add the video layer as a sublayer of `UIImageView`, which displays a screen shot of user's training image.
