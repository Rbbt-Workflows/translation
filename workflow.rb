require 'rbbt'
require 'rbbt/util/misc'
require 'rbbt/workflow'
require 'rbbt/sources/organism'
require 'translation'

module Translation
  extend Workflow

  self::FORMATS = Persist.persist("Translation identifiers", :array){ Organism.identifiers("Hsa").all_fields }

  input :organism, :string, "Organism code", "Hsa"
  def self.formats(organism)
    Organism.identifiers(organism).all_fields
  end
  task :formats => :array

  input :organism, :string, "Organism code", "Hsa"
  input :format, :select, "Target identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :genes, :array, "Gene id list"
  def self.translate(organism, format, genes)
    raise ParameterException, "No genes given" if genes.nil?
    index = index(organism, format)
    index.unnamed = true
    index.chunked_values_at(genes)
  end
  task :translate => :array

  input :organism, :string, "Organism code", "Hsa"
  input :target_format, :select, "Target identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :source_format, :select, "Source identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :genes, :array, "Gene id list"
  def self.translate_from(organism, format, source, genes)
    raise ParameterException, "No genes given" if genes.nil?
    index = index(organism, format, source)
    index.unnamed = true
    index.values_at(*genes)
  end
  task :translate_from => :array

  input :organism, :string, "Organism code", "Hsa"
  input :format, :select, "Target identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :genes, :array, "Gene id list"
  def self.tsv_translate(organism, format, genes)
    raise ParameterException, "No genes given" if genes.nil?
    index = index(organism, format)
    tsv = {}
    genes.each do |gene|
      tsv[gene] = index[gene]
    end
    TSV.setup(tsv, :key_field => "Gene", :fields => [format], :type => :single, :namespace => organism)
  end
  task :tsv_translate => :tsv

  input :organism, :string, "Organism code", "Hsa"
  input :target_format, :select, "Target identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :source_format, :select, "Source identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :genes, :array, "Gene id list"
  def self.tsv_translate_from(organism, format, source, genes)
    raise ParameterException, "No genes given" if genes.nil? 
    index = index(organism, format, source)
    tsv = TSV.setup({}, :key_field => source, :fields => [format], :type => :single)
    genes.each do |gene|
      tsv[gene] = index[gene]
    end
    tsv
  end
  task :tsv_translate_from => :tsv
  export_exec :formats, :translate, :translate_from, :tsv_translate, :tsv_translate_from


  input :organism, :string, "Organism code", "Hsa"
  input :source_format, :select, "Source identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :target_format, :select, "Target identifier format", "Ensembl Gene ID", :select_options => FORMATS
  input :genes, :array, "Gene id list"
  def self.tsv_translate_multiple(organism, source_format, target_format, genes)
    raise ParameterException, "No genes given" if genes.nil?
    index = index_flat(organism, target_format, source_format)
    tsv = {}
    genes.each do |gene|
      tsv[gene] = index[gene]
    end
    TSV.setup(tsv, :key_field => source_format, :fields => [target_format], :type => :flat, :namespace => organism)
  end
  task :tsv_translate_multiple => :tsv

  #{{{ Protein
  
  input :organism, :string, "Organism code", "Hsa"
  input :format, :select, "Target identifier format", "Ensembl Protein ID", :select_options => FORMATS
  input :proteins, :array, "Protein id list"
  def self.translate_protein(organism, format, proteins)
    raise ParameterException, "No proteins given" if proteins.nil?
    index = protein_index(organism, format)
    index.chunked_values_at(proteins)
  end
  task :translate_protein => :array

  input :organism, :string, "Organism code", "Hsa"
  input :target_format, :select, "Target identifier format", "Ensembl Protein ID", :select_options => FORMATS
  input :source_format, :select, "Source identifier format", "Ensembl Protein ID", :select_options => FORMATS
  input :proteins, :array, "Protein id list"
  def self.translate_protein_from(organism, format, source, proteins)
    raise ParameterException, "No proteins given" if proteins.nil?
    index = protein_index(organism, format, source)
    index.values_at(*proteins)
  end
  task :translate_protein_from => :array

  input :organism, :string, "Organism code", "Hsa"
  input :format, :select, "Target identifier format", "Ensembl Protein ID", :select_options => FORMATS
  input :proteins, :array, "Protein id list"
  def self.tsv_translate_protein(organism, format, proteins)
    raise ParameterException, "No proteins given" if proteins.nil?
    index = protein_index(organism, format)
    tsv = TSV.setup({}, :key_field => "Protein", :fields => [format])
    proteins.each do |protein|
      tsv[protein] = index[protein]
    end
    tsv
  end
  task :tsv_translate_protein => :tsv

  input :organism, :string, "Organism code", "Hsa"
  input :target_format, :select, "Target identifier format", "Ensembl Protein ID", :select_options => FORMATS
  input :source_format, :select, "Source identifier format", "Ensembl Protein ID", :select_options => FORMATS
  input :proteins, :array, "Protein id list"
  def self.tsv_translate_protein_from(organism, target, source, proteins)
    raise ParameterException, "No proteins given" if proteins.nil?
    index = protein_index(organism, target, source)
    tsv = TSV.setup({}, :key_field => source, :fields => [target])
    proteins.each do |protein|
      tsv[protein] = index[protein]
    end
    tsv
  end
  task :tsv_translate_protein_from => :tsv
  export_exec :translate_protein, :translate_protein_from, :tsv_translate_protein, :tsv_translate_protein_from



  input :organism, :string, "Organism code", "Hsa"
  input :format, :select, "Target identifier format", "Ensembl Transcript ID", :select_options => FORMATS
  input :probes, :array, "Probe id list"
  def self.translate_probe(organism, format, probes)
    raise ParameterException, "No probes given" if probes.nil?
    index = probe_index(organism, format)
    index.values_at(*probes)
  end
  task :translate_probe => :array

  input :organism, :string, "Organism code", "Hsa"
  input :target_format, :select, "Target identifier format", "Ensembl Transcript ID", :select_options => FORMATS
  input :source_format, :select, "Source identifier format", "Ensembl Transcript ID", :select_options => FORMATS
  input :probes, :array, "Probe id list"
  def self.translate_probe_from(organism, format, source, probes)
    raise ParameterException, "No probes given" if probes.nil?
    index = probe_index(organism, format, source)
    index.values_at(*probes)
  end
  task :translate_probe_from => :array

  input :organism, :string, "Organism code", "Hsa"
  input :format, :select, "Target identifier format", "Ensembl Transcript ID", :select_options => FORMATS
  input :probes, :array, "Probe id list"
  def self.tsv_translate_probe(organism, format, probes)
    raise ParameterException, "No probes given" if probes.nil?
    index = probe_index(organism, format)
    tsv = TSV.setup({}, :key_field => "Transcript", :fields => [format])
    probes.each do |probe|
      tsv[probe] = index[probe]
    end
    tsv
  end
  task :tsv_translate_probe => :tsv

  input :organism, :string, "Organism code", "Hsa"
  input :target_format, :select, "Target identifier format", "Ensembl Transcript ID", :select_options => FORMATS
  input :source_format, :select, "Source identifier format", "Ensembl Transcript ID", :select_options => FORMATS
  input :probes, :array, "Probe id list"
  def self.tsv_translate_probe_from(organism, target, source, probes)
    raise ParameterException, "No probes given" if probes.nil?
    index = probe_index(organism, target, source)
    tsv = TSV.setup({}, :key_field => source, :fields => [target])
    probes.each do |probe|
      tsv[probe] = index[probe]
    end
    tsv
  end
  task :tsv_translate_probe_from => :tsv


  input :organism, :string, "Organism code", "Hsa"
  input :transcripts, :array, "Ensembl Transcript ID"
  def self.transcript_to_protein(organism, transcripts)
    raise ParameterException, "No transcripts given" if transcripts.nil? 
    index = transcript_to_protein_index(organism)

    index.values_at(*transcripts)
  end
  task :transcript_to_protein => :array
  
  export_exec :translate_probe, :translate_probe_from, :tsv_translate_probe, :tsv_translate_probe_from, :transcript_to_protein, :tsv_translate_multiple

end
