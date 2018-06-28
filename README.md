# CDCoreDataFileSystemBlob

Associate data (blob) to NSManagedObjects and store it to file system instead of the database.


### CocoaPods (Podfile)

`pod 'CDCoreDataFileSystemBlob', :git => 'https://github.com/ChristianDeckert/CDCoreDataFileSystemBlob.git', :branch => 'master'`

### Examples

##### Storing data

```swift
let cat: NSManagedObject = [...] // a valid stored managed object from your database
let imageData: Data = nsImage.tiffRepresentation
cat.store(data: imageData, for: "pictureOfCat") // store data for key "pictureOfCat"
```

##### Loading data

```swift
let cat: NSManagedObject = [...] // a valid object from your database
guard let imageData = cat.data(for: "pictureOfCat") else { return } // load data for key "pictureOfCat"
let pictureOfCat = NSImage(data: imageData)
```

##### Deleting

```swift
cat.deleteData(for: "pictureOfCat")
cat.deleteAllData() // for all keys (basically removes whole cache folder from file system)
```

##### Filesystem

All data is stored at a unique location inside your apps' documents folder.

`/Users/<USER>/Library/Containers/<REVERSEDOMAIN>/Data/Documents/CDCoreDataFileSystemBlob/DB4DAB0A-AFE8-4F70-96E2-217FFF75C704/p56/pictureOfCat`
