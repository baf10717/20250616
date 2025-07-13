# -*- coding: utf-8 -*-
"""Simple command line program that greets the user."""

def main():
    """Prompt for the user's name and print a greeting."""
    # Prompt the user to enter their name. The text is in Chinese as requested.
    name = input('你的名字？ ')

    # Display a greeting using an f-string to insert the name.
    print(f"Hello, {name}!")


if __name__ == '__main__':
    # Run the main function when executed as a script.
    main()

