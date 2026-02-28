#!/usr/bin/env python3
"""
Compatibility shim — delegates to the abopus package.

Install with: pip install -e . (or pipx install abopus)
Then use the 'abopus' command directly.
"""

import sys

try:
    from abopus.converter import main
except ImportError:
    # When run directly without installing the package, add src/ to path
    from pathlib import Path

    sys.path.insert(0, str(Path(__file__).resolve().parent / "src"))
    from abopus.converter import main

if __name__ == "__main__":
    sys.exit(main())
