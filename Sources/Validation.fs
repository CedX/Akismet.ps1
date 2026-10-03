namespace Belin.Akismet

open System
open System.Management.Automation
open System.Text

/// Validates that the specified character encoding exists.
type ValidateEncodingAttribute(errorMessage: string) =
  inherit ValidateArgumentsAttribute()

  /// Verifies that the value of `arguments` is valid.
  override _.Validate(arguments: obj, _: EngineIntrinsics) =
    let exists =
      match arguments with
      | :? string as name -> String.IsNullOrEmpty name || Encoding.GetEncodings() |> Array.exists (fun encoding -> encoding.Name = name)
      | _ -> false

    if not exists then raise (ValidationMetadataException errorMessage)
