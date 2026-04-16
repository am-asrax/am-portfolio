from setuptools import setup, find_packages

setup(
    name="finance_ai",
    version="0.1",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.8",
    install_requires=[
        "pydantic>=2.0.0",
        "pandas>=1.3.0",
        "python-dateutil>=2.8.2",
    ],
)
