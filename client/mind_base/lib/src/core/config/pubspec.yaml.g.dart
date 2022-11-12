/// GENERATED CODE - DO NOT MODIFY BY HAND

/// ***************************************************************************
/// *                            pubspec_generator                            * 
/// ***************************************************************************

/*
  
  MIT License
  
  Copyright (c) 2022 Plague Fox
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
   
 */

// The pubspec file:
// https://dart.dev/tools/pub/pubspec

// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: unnecessary_raw_strings
// ignore_for_file: use_raw_strings
// ignore_for_file: avoid_escaping_inner_quotes
// ignore_for_file: prefer_single_quotes

/// Current app version
const String version = r'1.0.0+1';

/// The major version number: "1" in "1.2.3".
const int major = 1;

/// The minor version number: "2" in "1.2.3".
const int minor = 0;

/// The patch version number: "3" in "1.2.3".
const int patch = 0;

/// The pre-release identifier: "foo" in "1.2.3-foo".
const List<String> pre = <String>[];

/// The build identifier: "foo" in "1.2.3+foo".
const List<String> build = <String>[r'1'];

/// Build date in Unix Time (in seconds)
const int timestamp = 1666509554;

/// Name [name]
const String name = r'mind_base';

/// Description [description]
const String description = r'A new Flutter project.';

/// Repository [repository]
const String repository = r'';

/// Issue tracker [issue_tracker]
const String issueTracker = r'';

/// Homepage [homepage]
const String homepage = r'';

/// Documentation [documentation]
const String documentation = r'';

/// Publish to [publish_to]
const String publishTo = r'none';

/// Environment
const Map<String, String> environment = <String, String>{
  'sdk': '>=2.18.2 <3.0.0',
};

/// Dependencies
const Map<String, Object> dependencies = <String, Object>{
  'flutter': <String, Object>{
    'sdk': r'flutter',
  },
  'flutter_localizations': <String, Object>{
    'sdk': r'flutter',
  },
  'get_arch_core': <String, Object>{
    'git': <String, Object>{
      'url': r'https://github.com/GetArch/get_arch_core.git',
      'ref': r'v4.1',
    },
  },
  'provider_sidecar': <String, Object>{
    'git': <String, Object>{
      'url': r'https://github.com/Hu-Wentao/provider_sidecar',
      'ref': r'v1.4',
    },
  },
  'slowly': <String, Object>{
    'git': <String, Object>{
      'url': r'https://github.com/GetArch/slowly.git',
      'ref': r'v1.0',
    },
  },
  'get_sweet': <String, Object>{
    'git': <String, Object>{
      'url': r'https://github.com/GetArch/get_sweet.git',
      'ref': r'v1.0',
    },
  },
  'appwrite': r'8.1.0',
  'dart_appwrite': r'^7.1.0',
  'flutter_form_builder': r'7.1.1',
  'form_builder_validators': r'7.9.0',
};

/// Developer dependencies
const Map<String, Object> devDependencies = <String, Object>{
  'flutter_test': <String, Object>{
    'sdk': r'flutter',
  },
  'flutter_lints': r'^2.0.0',
};

/// Dependency overrides
const Map<String, Object> dependencyOverrides = <String, Object>{
  'provider_sidecar': <String, Object>{
    'path': r'../../../provider_sidecar',
  },
  'pluto_grid': <String, Object>{
    'git': <String, Object>{
      'url': r'https://gitee.com/hu_wt/pluto_grid.git',
      'ref': r'feat_on_col_moved_evt',
    },
  },
};

/// Executables
const Map<String, Object> executables = <String, Object>{};

/// Source data from pubspec.yaml
const Map<String, Object> source = <String, Object>{
  'name': name,
  'description': description,
  'repository': repository,
  'issue_tracker': issueTracker,
  'homepage': homepage,
  'documentation': documentation,
  'publish_to': publishTo,
  'version': version,
  'environment': environment,
  'dependencies': dependencies,
  'dev_dependencies': devDependencies,
  'dependency_overrides': dependencyOverrides,
  'flutter': <String, Object>{
    'uses-material-design': true,
    'assets': <Object>[
      r'assets/icons/',
      r'assets/images/',
    ],
  },
  'flutter_gen': <String, Object>{
    'output': r'lib/src/core/config/assets/',
    'integrations': <String, Object>{
      'flutter_svg': true,
    },
  },
};
