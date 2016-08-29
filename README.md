# seek-stackable
iOS framework for laying out nested views vertically and horizontally.

# History

We wanted to be able to layout variable height UITableViewCell's without paying a penalty in scrolling smoothness and without having to maintain frame layout code.

# Why use stackable?
- It's just frames
- Get the performance of frame layout without lots of code
- Declarative view expression makes for easy integration in code
- Frames can be cached
- Frames are immutable
- Integration with various controls is extensible using protocol extensions
- Interfaces with standard UIKit controls
- Currently used by the SEEK iOS App for Search Results

# What it's not
- stackable is not a replacement for UIStackView
  - stackable is not meant to be dynamic like UIStackView, relying in immutable frames instead
  - Currently a number of features in UIStackView are not available in stackable such as alignment options but that will change over time
- stackable is not based on AutoLayout
  - AutoLayout is powerful but difficult to tune for performance

## example

```
  let descriptionLabel = UILabel()
  let attribute1 = UILabel()
  let attribute2 = UILabel()
  let attribute3 = UILabel()
  let logoImageView = UIImageView()
  
  return VStack(spacing: 2, thingsToStack: [
    HStack(spacing: 10, thingsToStack: [
      VStack(spacing: 1, thingsToStack: [
        attribute1,
        attribute2,
        attribute3
      ]),
      logoImageView.stackSize(100, 100)
    ])
    descriptionLabel
  ])
```
