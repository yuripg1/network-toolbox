# Ping analyzer

## Summary

This test provides a better view of outages detected by one or more ping commands by analyzing them all and outputting a CSV containing only the outage windows.

## Instructions

### Running the ping commands

The first step is to run **ping** commands to the targets of interest.

The ping command must include the following arguments:

* **-D** (Print timestamps)
* **-n** (No reverse DNS name resolution)
* **-O** (Report outstanding replies)

You must also have the output of the ping command saved to a file. Here's an example:

```
$ ping -c 1800 -D -n -O -6 2001:12f8:b:1::8 > ./pings.txt
```

### Running the ping analysis script

The second step is to run the ping analysis script pointing to one or more files containing outputs of **ping** commands using the **--input** argument. The **--input** argument can be a single file, a directory or a pattern.

Here's an example of how to run it:

```shell
$ python3 ./ping_analyzer.py --input ./inputs
```

### Manual

```
usage: ping_analyzer.py [-h] --input INPUT

Analyze ping results

options:
  -h, --help     show this help message and exit
  --input INPUT  Path to the input file(s)
```

## Example

In the **[pings.txt](./inputs/pings.txt)** file you can see the example of an input

In the **[test_output.txt](./test_output.txt)** file you can see the example of an output
