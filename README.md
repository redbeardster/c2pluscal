# C2PlusCal Transpiler

![Language](https://img.shields.io/badge/Language-OCaml-f18d03)
![Libraries](https://img.shields.io/badge/Libraries-FramaC-ff4001)
![Open Source](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)

❓ **A transpiler that converts C programs into PlusCal specifications**

📌 *Language:* OCaml

🔧 *Status:* In development

C2PlusCal translates C programs to [PlusCal][6] formal specifications.
PlusCal is an algorithm language created by [Leslie Lamport][7].
It is a formalism designed to make using formal methods easier.
PlusCal algorithm is automatically translated to a TLA+ model
that can be checked with TLA+ formal verification techniques.

The transpiler is developed as a [Frama-C][1] plugin.

Based on: [`C2TLA+ by Amira METHNI`](https://hal.science/hal-01314832/document)

> [!IMPORTANT]
> This software is still under development, and may not compile or run correctly.

## 📥 Compilation / Installation

### Requirements
- **OCaml** 5.1.1 or later
- **Frama-C** 30.0 (Zinc) or later
- **dune** 3.7 or later

### Installation

```bash
# Install dependencies
opam install frama-c dune

# Initialize environment
eval $(opam env)

# Build and install
cd src
dune build
dune install
```

### Verification

```bash
frama-c -plugins | grep pluscal
```

## 🚀 Plugin Usage

To transpile a file e.g. `tests/basic/test_array.c` into PlusCal:

```bash
frama-c -pluscal tests/basic/test_array.c
```

or by using ``dune``

```bash
dune exec -- frama-c -pluscal tests/basic/test_array.c
```

🔹 This generates:
- **`test.tla`**: The PlusCal specification.
- **`test.cfg`**: The configuration file.

⚠️ Some knowledge of PlusCal syntax are necessary to understand the
generated code. Please refer to the section `TLA+ References` for a list of
resources.

⚠️ **Manual additions required**: **Invariants** and **Properties** must be written after the translation, under the `Inv` and `Prop` predicates. They can be automatically generated with the `-expect` option.

`test.tla` contains the algorithm of your translated C program.
This algorithm is put into a TLA+ module. From this module, you can run the
PlusCal translator to generate a TLA+ model that can be checked by TLC model checker.
Please refer to [the TLA+ website][6] for more information about using TLA+ tools.


### 🛠️ Plugin Options

- **`-debug-dump`**: Generates a `.dump` file containing debug information.
- **`-check-label <fun_name>`**:
    Adds a `"Check_fun_name"` label before the end of specified functions,
    allowing properties or invariants to be inserted on local variables before
    they are removed from the stack.
    Can also be used with multiple functions : **`-check-label <fun1>,<fun2>`**
- **`-expect <file.expect>`**: Generates invariants in the `.cfg` file with the expecting
                                 value of variables of the program, written in the`.expect` file

### How to model check the generated PlusCal algorithm ?

Once your `.tla`/`.cfg` files are generated, you can call the PlusCal Translator
(in your favorite editor) to generate TLA+ specification.

Then, you can call the TLC model checker to check the specification.


⚠️  C2PlusCal uses the `Bitwise.tla` module (available in
[CommunityModules repository][9]) which is not a standard TLA+ module.
If your C code uses bitwise operations, you need to add this module.
In this case, refer to steps described in the section *How to use it* of
[CommunityModules repository][9].
Otherwise, you can just remove it from the list of imported modules.


## 🧪 Testing

Run the test suite:

```bash
cd tests
python3 run_tests.py
```

Or using Make:

```bash
make test
```

See [`tests/README.md`](./tests/README.md) for details.

## ✅ Verification with TLA+ Toolbox

After generating PlusCal specifications, verify them with TLC model checker:

```bash
# Generate specification
frama-c -pluscal tests/test_simple.c

# Open test_simple.tla in TLA+ Toolbox
# Press Ctrl+T to translate, then F11 to verify
```

See [`QUICKSTART_TLA.md`](./QUICKSTART_TLA.md) for quick start or [`doc/tla_toolbox_guide.md`](./doc/tla_toolbox_guide.md) for detailed guide.

## Documentation

📄 **Full documentation available in [`doc/`](./doc/)**.

## TLA+ References

If you want to start with TLA+, the above references are basic points to get
started:

- [The TLA+ Home Page][6] by Leslie Lamport's website
- [Learn TLA+][8] by Hillel Wayne

## Context

C2PlusCal was developed was developed by [Guillaume Di Fatta][5] as part of a five-month internship at [Asterios Technologies][3], subsidiary of Safran Electronics and Defense. The original idea behind C2PlusCal was to strengthen verification processes of embedded safety-critical software written in C, used in airborne systems.

For more information, see the presentation ***Translating C to PlusCal for Model Checking of Safety Properties on Source Code*** at [TLA+ Community Event 2025][4]:
[[📄 Slides][10] ] | [[📹 Video][11] ] | [[❔ Q&A][12] ]

## License

Apache License 2.0—see [LICENSE](./LICENSE) file.

[1]: https://frama-c.com/
[2]: https://ocaml.org
[3]: https://www.safran-group.com/companies/asterios-technologies
[4]: https://conf.tlapl.us/2025-etaps/
[5]: https://github.com/Atafid
[6]: https://lamport.azurewebsites.net/tla/tla.html
[7]: https://fr.wikipedia.org/wiki/Leslie_Lamport
[8]: https://learntla.com
[9]: https://github.com/tlaplus/CommunityModules
[10]: https://conf.tlapl.us/2025-etaps/di-fatta-slides.pdf
[11]: https://youtu.be/0A5qMWvFgdI
[12]: https://youtu.be/NgYIS02EUnI
