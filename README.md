# Puppet Module
# `gajdaw/php5`

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)

## Overview

The module installs php5 using `ppa:ondrej/php5` repository.

**CAUTION**

This module manages in fact both: `php5` and `apache`!

## Setup

To install the module run:

    sudo puppet install module gajdaw-php5

## Usage

You can use the module running the following command:

    sudo puppet apply -e 'include php5'

The examples are located in `examples/` directory.

## Limitations

The module was tested on all the platforms that appear in `metadata.json`.
