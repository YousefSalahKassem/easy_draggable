# EasyDraggableWidget

https://github.com/YousefSalahKassem/easy_draggable/assets/91211054/2f872856-9d7b-4dc0-bd96-6e4bd0e5add4


The `EasyDraggableWidget` is a Flutter widget that allows you to easily create a draggable floating widget on the screen. This widget provides intuitive drag-and-drop functionality and additional features such as bouncing effect, collision detection, and auto-alignment.

## Usage

To use the `EasyDraggableWidget`, follow these steps:

1. Add the `easy_draggable` package to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_draggable: <version>
```

2. Import the necessary packages:

```dart
import 'package:easy_draggable/easy_draggable.dart';
import 'package:flutter/material.dart';
```

3. Create an instance of the `EasyDraggableWidget` and provide the required parameters:
   
```dart
EasyDraggableWidget(
  padding: EdgeInsets.zero,
  floatingBuilder: (context, constraints) {
    // Return the content of the floating widget here
    // This builder function will be called to build the floating widget
    // whenever the widget needs to be rebuilt.
  },
  // Set other optional parameters as needed
)

```

## Parameters

The `EasyDraggableWidget` constructor accepts the following parameters:

| Parameter        | Type                   | Description                                                                                          | Default        |
|------------------|------------------------|------------------------------------------------------------------------------------------------------|----------------|
| padding          | EdgeInsetsGeometry     | The padding around the widget.                                                                       | EdgeInsets.zero|
| floatingBuilder  | LayoutWidgetBuilder    | A builder function that returns the content of the floating widget.                                   | -              |
| top              | double?                | The initial distance from the top of the screen.                                                     | -              |
| left             | double?                | The initial distance from the left of the screen.                                                    | -              |
| bottom           | double?                | The initial distance from the bottom of the screen.                                                  | -              |
| right            | double?                | The initial distance from the right of the screen.                                                   | -              |
| speed            | double?                | The speed factor for the widget movement when released.                                              | null           |
| isDraggable      | bool                   | Determines whether the widget is draggable or not.                                                   | true           |
| hasBounce        | bool                   | Determines whether the widget should bounce when it touches the screen borders.                     | false          |
| autoAlign        | bool                   | Determines whether the widget should automatically align to the left or right side of the screen.   | false          |

**Note**: You only need to specify either `left` or `right`, and either `top` or `bottom` for the initial state of the widget. Providing both `left` and `right`, or both `top` and `bottom`, is not necessary.

## Example

Here's an example of how to use the EasyDraggableWidget:

```dart
EasyDraggableWidget(
          padding: const EdgeInsets.all(16),
          floatingBuilder: (context, constraints) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Drag me!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
```

This example creates a draggable blue container with centered text inside. You can customize the content of the floating widget by providing your own builder function.

Note: Make sure to replace <version> with the appropriate version of the easy_draggable package you want to use.

That's it! You now have a draggable floating widget on your screen.
