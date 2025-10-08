# .NET/Unity Stack Rules

This document contains .NET and Unity-specific conventions that extend the base rules.

## Version

**Stack**: dotnet
**Version**: 1.0.0
**Last Updated**: 2025-10-08

## .NET Naming Conventions

### R-DOTNET-010: Follow C# Naming Conventions
- **PascalCase** for public members, types, namespaces
- **camelCase** with `_` prefix for private fields
- **PascalCase** for properties (even private ones)
- **UPPER_CASE** for constants

**Examples:**
```csharp
public class PlayerController  // PascalCase
{
    private int _health;        // _camelCase
    public int MaxHealth { get; set; }  // PascalCase property
    private const int MAX_RETRIES = 3;   // UPPER_CASE
}
```

### R-DOTNET-020: Unity-Specific Conventions
- Use `[SerializeField]` for inspector-visible private fields
- Prefer `[field: SerializeField]` for auto-properties in Unity 2020.1+
- Use `[Header("Section")]` and `[Tooltip("Description")]` for inspector organization

**Example:**
```csharp
[SerializeField] private float _moveSpeed = 5f;
[field: SerializeField] public int Score { get; private set; }
```

## Project Structure

### R-DOTNET-030: Respect Solution Structure
- Keep `.csproj` files in their designated directories
- Follow existing namespace hierarchy
- Place tests in `tests/` directories with `.Tests` suffix
- Use `src/` for source code, `tests/` for test code

### R-DOTNET-040: Use Directory.Build.props
- Central package management in `Directory.Build.props` or `Directory.Packages.props`
- Don't duplicate package versions across projects
- Follow established versioning strategy

## Testing

### R-DOTNET-050: Use xUnit for .NET Tests
- Test projects should use xUnit framework
- Test classes should end with `Tests` suffix (e.g., `PlayerControllerTests`)
- Use `[Fact]` for simple tests, `[Theory]` for parameterized tests
- Follow AAA pattern (Arrange, Act, Assert)

### R-DOTNET-060: Unity Test Framework
- Unity tests go in `Tests~` folders (hidden from Unity)
- Use Unity Test Framework (UTF) for Unity-specific tests
- Separate EditMode and PlayMode tests
- Mark flaky tests with `[Ignore]` and document reason

## Build & Development

### R-DOTNET-070: Format Before Commit
- Run `dotnet format` before committing .NET code
- Use solution-level formatting for consistency
- Pre-commit hooks will enforce formatting

### R-DOTNET-080: Solution File Management
- Keep solution files (`.sln`) up to date
- Use solution folders to organize projects
- Document any manual solution modifications

## ECS-Specific (Arch)

### R-DOTNET-090: Arch ECS Conventions
- Components are structs, not classes
- Systems inherit from `SystemBase`
- Queries use `World.Query<TComponent1, TComponent2>()`
- Entity handles are lightweight value types

## Compatibility

These rules are compatible with:
- Base rules v1.1.0
- .NET 6.0+
- Unity 2020.3 LTS+
- Arch ECS library
