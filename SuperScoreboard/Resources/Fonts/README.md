# SuperScoreboard Design System

## Typography System

The SuperScoreboard app uses a comprehensive typography system with custom fonts and predefined styles for consistent design across the application.

### Font Styles

| Style | Font Family | Size | Weight | Usage |
|-------|-------------|------|---------|-------|
| `.headingsLarge` | Druk Wide Bold | 34px | 700 | Large competition headers |
| `.headingTitle3` | Druk Wide Bold | 16px | 700 | Competition titles |
| `.bodyMedium` | Selecta Medium | 16px | 500 | Team names, main body text |
| `.calloutBold` | Selecta Bold | 16px | 700 | Scores, emphasized text |
| `.bodySmall` | Selecta Regular | 12px | 400 | Secondary information |
| `.caption` | Selecta Medium | 12.94px | 500 | Venue names, captions |
| `.timeNumber` | Selecta Regular | 12px | 400 | Match time display |

### Usage Examples

```swift
// Large competition header
Text("CHAMPIONS LEAGUE")
    .customFont(.headingsLarge)

// Competition title
Text("Premier League")
    .customFont(.headingTitle3)

// Team name
Text("Manchester United")
    .customFont(.bodyMedium)

// Score display
Text("2 - 1")
    .customFont(.calloutBold)

// Match time
Text("90+2'")
    .customFont(.timeNumber)

// Venue information
Text("Old Trafford")
    .customFont(.caption)

// Secondary text
Text("Full Time")
    .customFont(.bodySmall)
```

## Color System

The SuperScoreboard design system includes three primary colors for consistent theming:

### Color Tokens

| Token | Hex Value | Opacity | Usage |
|-------|-----------|---------|-------|
| `.textIconDefaultBlack` | #1C1B19 | 100% | Primary text and icons |
| `.fillPrimary` | #787880 | 20% | Background fills, time containers |
| `.surfaceBase` | #FFFFFF | 100% | White backgrounds, light text |

### Color Usage Examples

```swift
// Primary text (default for all fonts)
Text("Manchester United")
    .customFont(.bodyMedium)  // Uses .textIconDefaultBlack by default

// White text on colored background
Text("90+2'")
    .customFont(.timeNumber, color: .surfaceBase)
    .padding(8)
    .background(.fillPrimary)

// Background fills
Rectangle()
    .fill(.fillPrimary)

// Surface backgrounds
VStack {
    // content
}
.background(.surfaceBase)
```

### Font + Color Combinations

```swift
// Competition headers
Text("CHAMPIONS LEAGUE")
    .customFont(.headingsLarge, color: .textIconDefaultBlack)

// Time display with background
Text("LIVE")
    .customFont(.timeNumber, color: .surfaceBase)
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(.fillPrimary)
    .cornerRadius(4)

// Score display
Text("2")
    .customFont(.calloutBold, color: .textIconDefaultBlack)
```

## Implementation Details

- **Smart Fallbacks**: System automatically falls back to native iOS fonts with matching weights if custom fonts are unavailable
- **Consistent Spacing**: All font styles include optimized line heights for proper vertical rhythm
- **Accessibility**: Colors meet WCAG contrast requirements for text readability
- **Performance**: Fonts are efficiently cached and reused throughout the app

## Testing

Use `FontTestView()` to preview all font styles and colors:

```swift
NavigationView {
    FontTestView()
}
```

This view displays all typography styles with both light and dark background variations for comprehensive testing.