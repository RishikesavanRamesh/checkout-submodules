# Submodule Checkout Action

This action checks out a private or public submodule hosted within GitHub.

## Inputs

### `pat`

A PAT used when checking out private submodules.

## Example usage

#### Public Submodules:

```
uses: rishikesavanramesh/checkout-submodules@v1
```

#### Private Submodules:

```
uses: rishikesavanramesh/checkout-submodules@v1
with:
  pat: '${{ secrets.PAT }}'
```