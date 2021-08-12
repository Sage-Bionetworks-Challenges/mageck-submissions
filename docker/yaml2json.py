#!/usr/bin/env python

"""Reformats YAML file to JSON."""

import argparse
import json

import yaml


def get_args():
    """Set up command-line interface and get arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("-y", "--yaml_file",
                        type=str, required=True)
    parser.add_argument("-o", "--output_file",
                        type=str, default="results.json")
    return parser.parse_args()


def main():
    """Main function."""
    args = get_args()
    with open(args.yaml_file) as y, open(args.output_file, "w") as out:
        out.write(json.dumps(yaml.safe_load(y)))


if __name__ == "__main__":
    main()
