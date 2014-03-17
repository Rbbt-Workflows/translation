Translation services for genes and proteins based on Ensembl

Genes and proteins may be referenced using a variety of identifier formats:
Ensembl, Entrez, UniProt, RefSeq, Affy probes, etc. Translating between
these names can be time consuming and error prone.

This workflow uses identifier translation files downloaded from Ensembl BioMart
to translate gene and protein identifiers between formats. The files are
downloaded separatedly for each organism and build, to account for changes
overtime that could introduce inconsistencies.

# Tasks

The `organism` input parameter defines the organism and build to use. For
instance *H*omo *sa*piens is written *Hsa*, and for the hg18 build you can
specify it as *Hsa/may2009*.

The `format` is specified using the same text as appears in BioMart. The most
important are:

  * Ensembl Gene ID
  * Associated Gene Name
  * UniProt/SwissProt ID
  * Entrez Gene ID

## transcript_to_protein
Translate transcript to their corresponding protein ids

## translate
Translate gene ids to a particular format

## translate_from
Translate gene ids to a particular format given in another format

## translate_probe
Translate probe ids to a particular format

## translate_probe_from
Translate probe ids to a particular format given in another format

## translate_protein
Translate protein ids to a particular format

## translate_protein_from
Translate protein ids to a particular format given in another format

## tsv_translate
Translate gene ids to a particular format. Return TSV

## tsv_translate_from
Translate gene ids to a particular format given in another format. Return TSV

## tsv_translate_probe
Translate probe ids to a particular format. Return TSV

## tsv_translate_probe_from
Translate probe ids to a particular format given in another format. Return TSV

## tsv_translate_protein
Translate protein ids to a particular format. Return TSV

## tsv_translate_protein_from
Translate protein ids to a particular format given in another format. Return
TSV


