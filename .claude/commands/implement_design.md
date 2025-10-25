Task: Convert Figma design to code

Steps:

1. Load the Figma design from the provided URL using Figma MCP
2. Analyze the design structure, layout, and components
3. Implement the design in code with accurate:
   - Layout and spacing
   - Colors and typography
   - Component hierarchy
   - Interactive elements
4. execute flutter analyze to remove errors

Implementation Requirements:

- Must implement design with precision, everytime you create new components, check figma design again and make a plan to implement it
- Must Ignore Bottom bar (Handle) and Status bar when you design full screen
- Prioritize using existing modular widgets from the project
- Create reusable, modular components for repeated UI patterns
- Use existing theme from lib/theme for colors and styles
- Utilize assets from assets/icon and assets/image folders
- Apply font families defined in pubspec.yaml
- Maintain consistency with the project's existing design system
- Avoid ColorFileter if it's not nessecary

Best Practices:

- Break down complex UI into smaller, reusable widgets
- Extract common patterns into separate widget files
- Keep widgets focused on single responsibilities
- Use composition over