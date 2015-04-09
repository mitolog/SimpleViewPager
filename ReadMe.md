# SimpleViewPager

SimpleViewPager is a UI Component like Android's ViewPager

![gif](https://dl.dropboxusercontent.com/u/91774212/simpleViewPager.gif)

## Desc
SimpleViewPager is mainly consist of 4 parts:
- MenuView... represents each page, containing scrollView to display title.
- ContentScrollView... displays each view produced by SomeViewController.
- SimpleViewController... manages MenuView above components.
- Main.storyboard... defines layouts of MenuView and ContentScrollView

## Spec
- Synchronous menus and content-views while scrolling horizontally
- Uses Storyboard
- Supports rotation
- Easy to customize because of minimum source code (Your contribution will be appriciated)
- Deployment target iOS 7.0

## How to use
1. Prepare each page component `MenuElem`.
 - name... represents page title.
 - className... UIViewController's subclass which holds a view to be pasted on SimpleViewController's scrollView.
 - sbName... Storyboard for class above.

2. Insert `MenuElem` to your desired position. (array index 0 will be the leftmost)

```swift:SimpleViewController.swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let menus: Array<MenuElem> =
    [
        MenuElem(name: "menu1", className: "SomeViewController", sbName: "Some"),
        MenuElem(name: "menu2", className: "SomeViewController", sbName: "Some"),
        MenuElem(name: "menu3", className: "SomeViewController", sbName: "Some"),
        MenuElem(name: "menu4", className: "SomeViewController", sbName: "Some"),
        MenuElem(name: "menu5", className: "SomeViewController", sbName: "Some"),
        MenuElem(name: "menu6", className: "SomeViewController", sbName: "Some"),
    ]

    self.menuView.setup(menus, delegate:self)
    self.setupContentScrollView(menus)
}
```

3. You can pass the any parameter to each viewController via `setupContentScrollView(menus: Array<MenuElem>)`.

```swift:SimpleViewController.swift
func setupContentScrollView(menus: Array<MenuElem>) {
    // http://app.coolors.co/e0acd5-3993dd-29e7cd-6a3e37-c7f0bd
    let colorPalette = [0xE0ACD5, 0x3993DD, 0x29E7CD, 0x6A3E37, 0xC7F0BD]
    var cnt = 0
    for menu in menus {
        let sb: UIStoryboard = UIStoryboard(name: menu.storyBoardName(), bundle: nil)
        let vc = sb.instantiateInitialViewController() as UIViewController
        vc.title = menu.name()
        vc.view.backgroundColor = UIColor(netHex: colorPalette[cnt%colorPalette.count])
        self.contentScrollView.addSubview(vc.view)
        self.vcs.append(vc)
        cnt++
    }
}
```

### License
MIT
