An assistant that helps your dribble training of basketball.

## Features

### Post Wall

> Presenting training posts from all of the other users.

Customize `WaterfallLayout` which inherits from `UICollectionViewLayout`.
Random height is given to each collection view cell.

Play training videos by `AVPlayerViewController` in AVKit.

### Training Menu

> Selecting a mode of dribbling that you want to drill in.

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

> Handle basketball to touch the pumping target node on the screen. Get points as many as you can within the time limit.



### Profile Page

> Show user's information, such as ID, following and follower's number and training history.

Embed training videos in `AVPlayerLayer`.
Add the video layer as a sublayer of `UIImageView`, which displays a screen shot of user's training image.