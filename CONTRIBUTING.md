# Contributing to World Hotels

Thank you for your interest in contributing to World Hotels! This document provides guidelines for contributing to this project.

---

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
3. [Development Setup](#development-setup)
4. [Coding Standards](#coding-standards)
5. [Commit Guidelines](#commit-guidelines)
6. [Pull Request Process](#pull-request-process)
7. [Reporting Bugs](#reporting-bugs)
8. [Suggesting Enhancements](#suggesting-enhancements)
9. [Questions](#questions)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards others

**Unacceptable behavior includes:**
- Harassment, trolling, or insulting comments
- Personal or political attacks
- Publishing private information without permission
- Other conduct which could reasonably be considered inappropriate

---

## How Can I Contribute?

### Types of Contributions

We welcome various types of contributions:

1. **Bug Reports** - Report issues you encounter
2. **Feature Requests** - Suggest new features
3. **Documentation** - Improve docs, guides, comments
4. **Code Contributions** - Fix bugs, implement features
5. **Design Improvements** - UI/UX enhancements
6. **Testing** - Add or improve test coverage
7. **Code Review** - Review pull requests

### Good First Issues

Looking for a place to start? Check issues labeled:
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `documentation` - Documentation improvements

---

## Development Setup

### Prerequisites

- Python 3.8+
- MySQL 8.0+
- Git
- Virtual environment tool

### Setup Steps

1. **Fork the repository**
```bash
   # Click "Fork" button on GitHub
```

2. **Clone your fork**
```bash
   git clone https://github.com/YOUR-USERNAME/world-hotels.git
   cd world-hotels
```

3. **Add upstream remote**
```bash
   git remote add upstream https://github.com/biplab12696969/design-and-development-of-a-website-biplab12696969.git
```

4. **Create virtual environment**
```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   venv\Scripts\activate     # Windows
```

5. **Install dependencies**
```bash
   pip install -r requirements.txt
   pip install -r requirements-dev.txt  # If exists
```

6. **Set up database**
```bash
   mysql -u root -p < database/schema.sql
   mysql -u root -p < database/sample_data.sql
```

7. **Configure application**
```bash
   cp config.example.py config.py
   # Edit config.py with your settings
```

8. **Run tests**
```bash
   python -m pytest  # If tests exist
```

9. **Start development server**
```bash
   python app.py
```

---

## Coding Standards

### Python Style Guide

We follow **PEP 8** style guide with some modifications:

**General:**
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 100 characters
- Use descriptive variable names
- Add docstrings to functions and classes

**Example:**
```python
def calculate_booking_price(base_price, discount_percentage, nights):
    """
    Calculate final booking price with discount.
    
    Args:
        base_price (float): Base price per night
        discount_percentage (int): Discount percentage (0-100)
        nights (int): Number of nights
    
    Returns:
        float: Final price after discount
    """
    total = base_price * nights
    discount = total * (discount_percentage / 100)
    return total - discount
```

### Naming Conventions

- **Variables/Functions:** `snake_case`
```python
  user_email = "user@example.com"
  def get_available_rooms():
```

- **Classes:** `PascalCase`
```python
  class BookingValidator:
```

- **Constants:** `UPPER_SNAKE_CASE`
```python
  MAX_BOOKING_DAYS = 30
  DEFAULT_CURRENCY = 'GBP'
```

- **Private methods:** `_leading_underscore`
```python
  def _validate_internal():
```

### HTML/CSS/JavaScript

**HTML:**
- Use semantic HTML5 elements
- Include proper `alt` attributes for images
- Maintain proper indentation (2 spaces)

**CSS:**
- Use meaningful class names
- Follow BEM methodology where appropriate
- Group related properties together

**JavaScript:**
- Use `const` and `let`, avoid `var`
- Use meaningful function names
- Add comments for complex logic

---

## Commit Guidelines

### Commit Message Format

We follow the **Conventional Commits** specification:
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat:** New feature
- **fix:** Bug fix
- **docs:** Documentation changes
- **style:** Code style changes (formatting, no logic change)
- **refactor:** Code refactoring
- **test:** Adding or updating tests
- **chore:** Maintenance tasks

### Examples

**Good commits:**
```bash
feat(booking): add multi-currency price display

Implemented currency conversion for booking prices.
Users can now view prices in GBP, USD, EUR, NPR, and INR.

Closes #42
```
```bash
fix(auth): prevent SQL injection in login

Updated login query to use parameterized statements
instead of string concatenation.
```
```bash
docs(readme): update installation instructions

Added missing step for database setup.
Clarified MySQL version requirements.
```

**Bad commits:**
```bash
# Too vague
update stuff

# No description
fix bug

# Too long subject
feat: add the ability for users to select their preferred currency from a dropdown menu in the navigation bar
```

### Commit Best Practices

**DO:**
- Keep commits atomic (one logical change per commit)
- Write clear, descriptive messages
- Reference issue numbers (`Closes #123`, `Fixes #456`)
- Use present tense ("add feature" not "added feature")

**DON'T:**
- Commit broken code
- Mix multiple unrelated changes
- Use vague messages ("fix", "update", "changes")
- Commit sensitive data (passwords, API keys)

---

## Pull Request Process

### Before Submitting

1. **Create a feature branch**
```bash
   git checkout -b feature/your-feature-name
```

2. **Make your changes**
   - Follow coding standards
   - Add tests if applicable
   - Update documentation

3. **Test thoroughly**
   - Run existing tests
   - Test manually
   - Check for errors

4. **Update documentation**
   - README if needed
   - Code comments
   - Docstrings

5. **Commit your changes**
```bash
   git add .
   git commit -m "feat(scope): description"
```

6. **Push to your fork**
```bash
   git push origin feature/your-feature-name
```

### Submitting a Pull Request

1. **Go to GitHub**
   - Navigate to the original repository
   - Click "New Pull Request"

2. **Select branches**
   - Base: `main` (original repo)
   - Compare: `feature/your-feature-name` (your fork)

3. **Fill in PR template**
```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   
   ## Testing
   How has this been tested?
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Comments added for complex code
   - [ ] Documentation updated
   - [ ] No new warnings generated
   - [ ] Tests added/updated
   - [ ] All tests passing
```

4. **Submit PR**

### PR Review Process

1. **Automated checks** run (if configured)
2. **Maintainer review** (may request changes)
3. **Discussion** and updates
4. **Approval** and merge

### After PR is Merged

1. **Delete your branch**
```bash
   git branch -d feature/your-feature-name
   git push origin --delete feature/your-feature-name
```

2. **Update your fork**
```bash
   git checkout main
   git pull upstream main
   git push origin main
```

---

## Reporting Bugs

### Before Reporting

1. **Check existing issues** - May already be reported
2. **Use latest version** - Bug may be fixed
3. **Reproduce consistently** - Ensure it's reproducible

### Bug Report Template
```markdown
**Bug Description**
Clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Screenshots**
If applicable, add screenshots

**Environment**
- OS: [e.g., Windows 10]
- Browser: [e.g., Chrome 120]
- Python Version: [e.g., 3.9.5]
- MySQL Version: [e.g., 8.0.28]

**Additional Context**
Any other relevant information
```

### Security Vulnerabilities

**Do NOT create public issues for security vulnerabilities!**

Instead:
1. Email: security@worldhotels.com
2. Include details privately
3. Allow time for fix before disclosure

---

## Suggesting Enhancements

### Feature Request Template
```markdown
**Feature Description**
Clear description of the feature

**Problem it Solves**
What problem does this solve?

**Proposed Solution**
How should it work?

**Alternatives Considered**
Other solutions you've considered

**Additional Context**
Mockups, examples, etc.
```

### Enhancement Guidelines

**Good feature requests:**
- Solve a real problem
- Align with project goals
- Include clear use cases
- Consider implementation complexity

**Avoid:**
- Duplicate requests (check existing issues)
- Out of scope features
- Breaking changes without strong justification

---

## Development Workflow

### Branch Naming

- **Features:** `feature/feature-name`
- **Bug fixes:** `fix/bug-description`
- **Documentation:** `docs/what-changed`
- **Hotfixes:** `hotfix/critical-issue`

**Examples:**
```bash
feature/multi-language-support
fix/booking-date-validation
docs/update-installation-guide
hotfix/security-patch
```

### Testing Guidelines

**Before submitting PR:**

1. **Manual Testing**
   - Test the specific feature/fix
   - Test related features
   - Test on different browsers (if UI change)
   - Test responsive design (if UI change)

2. **Automated Testing** (if applicable)
```bash
   python -m pytest
   python -m pytest tests/test_booking.py  # Specific test
```

3. **Code Quality**
```bash
   # Check PEP 8 compliance
   flake8 app.py
   
   # Check with pylint
   pylint app.py
```

### Database Changes

If your contribution includes database changes:

1. **Create migration script**
```sql
   -- migration_001_add_reviews_table.sql
   CREATE TABLE reviews (
       review_id INT PRIMARY KEY AUTO_INCREMENT,
       ...
   );
```

2. **Document changes**
   - Update ERD diagram
   - Update schema.sql
   - Update documentation

3. **Test thoroughly**
   - Test on fresh database
   - Test migration from existing data
   - Verify rollback works

---

## Code Review Guidelines

### For Authors

**When requesting review:**
- Provide context in PR description
- Highlight important changes
- Mention specific areas needing attention
- Respond to feedback promptly
- Don't take criticism personally

### For Reviewers

**When reviewing:**
- Be constructive and kind
- Explain why, not just what
- Suggest improvements
- Approve when satisfied
- Use these labels:
  - **LGTM** - Looks Good To Me
  - **SGTM** - Sounds Good To Me
  - **NIT** - Nitpick (minor suggestion)
  - **Q** - Question

**Review checklist:**
- [ ] Code follows style guidelines
- [ ] Logic is sound and efficient
- [ ] Error handling is appropriate
- [ ] Security best practices followed
- [ ] Tests are adequate
- [ ] Documentation is updated
- [ ] No debug code or comments
- [ ] Performance implications considered

---

## Questions?

### Getting Help

**Documentation:**
- [User Guide](docs/user_guide.md)
- [Admin Guide](docs/admin_guide.md)
- [Installation Guide](docs/installation_guide.md)
- [API Documentation](docs/api_documentation.md)

**Contact:**
- **General Questions:** Open a GitHub Discussion
- **Bug Reports:** Open an Issue
- **Security:** Email security@worldhotels.com
- **Maintainer:** Email biplab@example.com

### Community

- **GitHub Discussions** - Ask questions, share ideas
- **GitHub Issues** - Bug reports, feature requests

---

## Recognition

### Contributors

We recognize all contributors in:
- CONTRIBUTORS.md file
- Release notes
- Project README

### Types of Recognition

- **Code Contributors** - Merged pull requests
- **Documentation** - Documentation improvements
- **Bug Reporters** - Valuable bug reports
- **Idea Contributors** - Feature suggestions
- **Reviewers** - Code reviews

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

## Thank You!

Thank you for contributing to World Hotels! Your contributions help make this project better for everyone.

**Happy Coding!** 

---

*Contributing Guidelines - Last Updated: January 17, 2025*