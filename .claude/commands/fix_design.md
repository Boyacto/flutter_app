Task: Fix exsiting widget design with Figma design

Steps:

1. Load the Figma design from the provided URL using Figma MCP
2. Analyze the design structure, layout, and components
3. Find the matching widget in exsiting codebase
4. Compare both design and try to understand what is different 

Implementation Requirements:

- Must Ignore Bottom bar (Handle) and Status bar when you design full screen
- Prioritize using existing modular widgets from the project
- Create reusable, modular components for repeated UI patterns
- Use existing theme from lib/theme for colors and styles
- Utilize assets from assets/icon and assets/image folders
- Apply font families defined in pubspec.yaml
- Maintain consistency with the project's existing design system

Best Practices:

- Break down complex UI into smaller, reusable widgets
- Extract common patterns into separate widget files
- Keep widgets focused on single responsibilities
- Use composition over
