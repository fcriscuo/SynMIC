// Cypher to complete SynMic graph database

// CosmicHallmark
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/Cancer_Gene_Census_Hallmarks_Of_Cancer.tsv", { header:true,  sep:"TAB"})
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`GENE_NAME` IS  NULL
MERGE (n: `CosmicHallmark` { `halmark_id`: toInteger(lineNo) })
SET n.`gene_symbol` = nodeRecord.`GENE_NAME`
SET n.`cell_type` = nodeRecord.`CELL_TYPE`
SET n.`pub_id` = toInteger(trim(nodeRecord.`PUBMED_PMID`))
SET n.`hallmark` = nodeRecord.`HALLMARK`
SET n.`impact` = nodeRecord.`IMPACT`
SET n.`description` = nodeRecord.`DESCRIPTION`
',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicSample & CosmicSampleMutationCollection nodes
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"})
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`sample_id`)) IS NULL
MERGE (n: `CosmicSample` { `sample_id`: toInteger(trim(nodeRecord.`sample_id`)) })
MERGE (csmc: `CosmicSampleMutationCollection`{ `sample_id`: toInteger(trim(nodeRecord.`sample_id`)) })
MERGE  (n)-[r:HAS_MUTATION_COLLECTION]->(csmc)
SET n.`sample_name` = nodeRecord.`sample_name`
SET csmc.`sample_name` = nodeRecord.`sample_name`
SET n.`tumor_id` = toInteger(trim(nodeRecord.`id_tumour`))
SET n.`therapy_relationship` = nodeRecord.`therapy_relationship`
SET n.`sample_differentiator` = nodeRecord.`sample_differentiator`
SET n.`mutation_allele_specification` = nodeRecord.`mutation_allele_specification`
SET n.`msi` = nodeRecord.`msi`
SET n.`whole_genome_screen` = nodeRecord.`whole_genome_screen`
SET n.`whole_exome_screen` = nodeRecord.`whole_exome_screen`
SET n.`sample_remark` = nodeRecord.`sample_remark`
SET n.`germline_mutation` = nodeRecord.`germline_mutation`
SET n.`sample_type` = nodeRecord.`sample_type`
SET n.`cosmic_phenotype_id` = toInteger(trim(nodeRecord.`cosmic_phenotype_id`));
 ',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicPatient
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`id_individual`)) IS NULL
MERGE (n: `CosmicPatient` { `individual_id`: toInteger(trim(nodeRecord.`id_individual`)) })
SET n.`metastatic_site` = nodeRecord.`metastatic_site`
SET n.`tumor_id` = toInteger(trim(nodeRecord.`id_tumour`))
SET n.`age` = toInteger(trim(nodeRecord.`age`))
SET n.`ethnicity` = nodeRecord.`ethnicity`
SET n.`environmental_variables` = nodeRecord.`environmental_variables`
SET n.`therapy` = nodeRecord.`therapy`
SET n.`family` = nodeRecord.`family`
SET n.`normal_tissue_tested` = nodeRecord.`normal_tissue_tested`
SET n.`individual_remark` = nodeRecord.`individual_remark`
SET n.`gender` = nodeRecord.`gender`;
 ',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicTumor
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`id_tumour`)) IS NULL
MERGE (n: `Tumor` { `tumor_id`: toInteger(trim(nodeRecord.`id_tumour`)) })
SET n.`drug_response` = nodeRecord.`drug_response`
SET n.`grade` = nodeRecord.`grade`
SET n.`age_at_tumor_recurrence` = nodeRecord.`age_at_tumour_recurrence`
SET n.`stage` = nodeRecord.`stage`
SET n.`nci_code` = nodeRecord.`nci_code`;
',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicGeneCensus
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/cancer_gene_census.csv", { header:true,
mapping:{
     `Tumour Types(Somatic)`: {array:true, arraySep:",", name:"tumor_types_somatic"},
     `Tumour Types(Germline)`: {array:true, arraySep:",", name:"tumor_types_germline"},
     `Translocation Partner`: {array:true, arraySep:",", name:"translocation_partners"},
      `Mutation Types`: {array:true, arraySep:",", name:"mutation_types"},
      `Other Syndrome`: {array:true, arraySep:",", name:"other_syndromes"},
     Synonyms: {array:true, arraySep:",", name:"synonyms"}
   }
}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`Gene Symbol` IS NULL
MERGE (n: `CosmicGene` { gene_symbol: nodeRecord.`Gene Symbol` })
MERGE (cgmc: `CosmicGeneMutationCollection` {gene_symbol: nodeRecord.`GeneSymbol`})
MERGE (n)-[r:HAS_MUTATION_COLLECTION]->(cgmc)
SET n.`gene_name` = nodeRecord.`Name`
SET n.`entrez_gene_id` = toInteger(trim(nodeRecord.`Entrez GeneId`))
SET n.`genome_location` = nodeRecord.`Genome Location`
SET n.`tier` = toInteger(trim(nodeRecord.`Tier`))
SET n.`hallmark` = nodeRecord.`Hallmark`
SET n.`chr_band` = toFloat(trim(nodeRecord.`Chr Band`))
SET n.`somatic` = nodeRecord.`Somatic`
SET n.`germline` = nodeRecord.`Germline`
SET n.`tumor_types_somatic` = nodeRecord.`tumor_types_somatic`
SET n.`tumor_types_germline` = nodeRecord.`tumor_types_germline`
SET n.`cancer_syndrome` = nodeRecord.`Cancer Syndrome`
SET n.`tissue_type` = nodeRecord.`Tissue Type`
SET n.`molecular_genetics` = nodeRecord.`Molecular Genetics`
SET n.`role_in_cancer` = nodeRecord.`Role in Cancer`
SET n.`mutation_types` = nodeRecord.`mutation_types`
SET n.`translocation_partners` = nodeRecord.`translocation_partners`
SET n.`other_germline_mut` = nodeRecord.`Other Germline Mut`
SET n.`other_syndromes` = nodeRecord.`other_syndromes`
SET n.`cosmic_id` = nodeRecord.`COSMIC ID`
SET n.`cosmic gene name` = nodeRecord.`cosmic gene name`
SET n.cosmic_url= replace("https://cancer.sanger.ac.uk/cosmic/gene/analysis?ln=XXXX", "XXXX",n.gene_symbol)
SET n.`synonyms` = nodeRecord.synonyms;
',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicGene to CosmicGeneHallmarkCollection relationship
MATCH(gene:CosmicGene) WHERE gene.is_hallmark = 'yes'
MERGE (hgc:HallmarkGeneCollection{gene_symbol:hallmark.gene_symbol})
MERGE (gene)-[r:HAS_HALLMARK_COLLECTION]-(hgc);

// Link CosmicGene translocation partners
MATCH (gene:CosmicGene) WHERE  gene.translocation_partners IS NOT NULL
UNWIND gene.translocation_partners AS translocation
MATCH(partner:CosmicGene) WHERE partner.gene_symbol=translocation
MERGE (gene)-[r:HAS_TRANSLOCATION_PARTNER]-(partner)
;

// Add URL to Entrez Gene page if Entrez ID is available
MATCH (cg:CosmicGene) WHERE cg.entrez_id is not null
SET cg.entrez_gene_url= replace("https://www.ncbi.nlm.nih.gov/gene/?term=XXXX","XXXX",cg.entrez_id)
MATCH (eg:EntrezGene) WHERE eg.gene_id = cg.entrez_id
MERGE (cg)-[r1:HAS_ENTREZ_GENE]-(eg)
;

// CosmicMutation
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicMutantExportCensus.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  toInteger(trim(nodeRecord.`MUTATION_ID`)) IS NULL
MERGE (n: `CosmicMutation` { `mutation_id`: toInteger(trim(nodeRecord.`MUTATION_ID`)) })
SET n.`gene_symbol` = nodeRecord.`Gene name`
SET n.`accession_number` = nodeRecord.`Accession Number`
SET n.`cds_length` = toInteger(trim(nodeRecord.`Gene CDS length`))
SET n.`hgnc_id` = toInteger(trim(nodeRecord.`HGNC ID`))
SET n.`sample_name` = nodeRecord.`Sample name`
SET n.`sample_id` = toInteger(trim(nodeRecord.`ID_sample`))
SET n.`tumor_id` = toInteger(trim(nodeRecord.`ID_tumour`))
SET n.`primary_site` = nodeRecord.`Primary site`
SET n.`primary_histology` = nodeRecord.`Primary histology`
SET n.`genome_screen` = nodeRecord.`Genome-wide screen`
SET n.`genomic_mutation_id` = nodeRecord.`GENOMIC_MUTATION_ID`
SET n.`legacy_mutation_id` = nodeRecord.`LEGACY_MUTATION_ID`
SET n.`mutation_cds` = nodeRecord.`Mutation CDS`
SET n.`mutation_aa` = nodeRecord.`Mutation AA`
SET n.`mutation_description` = nodeRecord.`Mutation Description`
SET n.`Mutation zygosity` = nodeRecord.`Mutation zygosity`
SET n.`LOH` = nodeRecord.`LOH`
SET n.`GRCh` = toInteger(trim(nodeRecord.`GRCh`))
SET n.`mutation_genome_position` = nodeRecord.`Mutation genome position`
SET n.`mutation_strand` = nodeRecord.`Mutation strand`
SET n.`resistance_mutation` = nodeRecord.`Resistance Mutation`
SET n.`mutation_somatic_status` = nodeRecord.`Mutation somatic status`
SET n.`pub_id` = toInteger(trim(nodeRecord.`Pubmed_PMID`))
SET n.`study_id` = toInteger(trim(nodeRecord.`ID_STUDY`))
SET n.`sample_type` = nodeRecord.`Sample Type`
SET n.`tumor_origin` = nodeRecord.`Tumour origin`
SET n.`Age` = toFloat(trim(nodeRecord.`Age`))
SET n.`tier` = toInteger(trim(nodeRecord.`Tier`))
SET n.`HGVSP` = nodeRecord.`HGVSP`
SET n.`HGVSC` = nodeRecord.`HGVSC`
SET n.`HGVSG` = nodeRecord.`HGVSG`;
',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicSampleClassification
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/classification.csv", { header:true}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`COSMIC_PHENOTYPE_ID` IS NULL
MERGE (n: `CosmicSampleClassification` { `cosmic_phenotype_id`: nodeRecord.`COSMIC_PHENOTYPE_ID` })
SET n.`site_primary` = nodeRecord.`SITE_PRIMARY`
SET n.`site_subtype1` = nodeRecord.`SITE_SUBTYPE1`
SET n.`site_subtype2` = nodeRecord.`SITE_SUBTYPE2`
SET n.`site_subtype33` = nodeRecord.`SITE_SUBTYPE3`
SET n.`histology` = nodeRecord.`HISTOLOGY`
SET n.`hist_subtype1` = nodeRecord.`HIST_SUBTYPE1`
SET n.`hist_subtype2` = nodeRecord.`HIST_SUBTYPE2`
SET n.`hist_subtype3` = nodeRecord.`HIST_SUBTYPE3`
SET n.`site_primary_cosmic` = nodeRecord.`SITE_PRIMARY_COSMIC`
SET n.`site_subtype1_cosmic` = nodeRecord.`SITE_SUBTYPE1_COSMIC`
SET n.`site_subtype2_cosmic` = nodeRecord.`SITE_SUBTYPE2_COSMIC`
SET n.`site_subtype3_cosmic` = nodeRecord.`SITE_SUBTYPE3_COSMIC`
SET n.`histology_cosmic` = nodeRecord.`HISTOLOGY_COSMIC`
SET n.`hist_subtype1_cosmic` = nodeRecord.`HIST_SUBTYPE1_COSMIC`
SET n.`hist_subtype3_cosmic` = nodeRecord.`HIST_SUBTYPE2_COSMIC`
SET n.`his_subtype3_cosmic` = nodeRecord.`HIST_SUBTYPE3_COSMIC`
SET n.`nci_code` = nodeRecord.`NCI_CODE`
SET n.`EFO` = nodeRecord.`EFO`;
',
{batchSize:1000, iterateList:true, parallel:true});

match (cl:CosmicSampleClassification) where cl.nci_code is not null 
set cl.url = replace("https://ncit.nci.nih.gov/ncitbrowser/ConceptReport.jsp?dictionary=NCI%20Thesaurus&code=XXXX","XXXX",cl.nci_code) ;

// CosmicStructuralMutation
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicStructExport.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  NOT toInteger(trim(nodeRecord.`MUTATION_ID`)) IS NULL
MERGE (n: `CosmicStructuralMutation` { `mutation_id`: toInteger(trim(nodeRecord.`MUTATION_ID`)) })
SET n.`sample_name` = nodeRecord.`Sample name`
SET n.`sample_id` = toInteger(trim(nodeRecord.`ID_SAMPLE`))
SET n.`tumor_id` = toInteger(trim(nodeRecord.`ID_TUMOUR`))
SET n.`mutation_type` = nodeRecord.`Mutation Type`
SET n.`GRCh` = toInteger(trim(nodeRecord.`GRCh`))
SET n.`description` = nodeRecord.`description`
SET n.`pub_id` = nodeRecord.`PUBMED_PMID`;
',
{batchSize:4000, iterateList:true, parallel:true});

// CosmicResistanceMutation
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicResistanceMutations.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`MUTATION_ID`)) IS NULL
MERGE (n: `CosmicResistanceMutation` { `identifier`: toInteger(line_no) })
SET n.`mutation_id` = toInteger(nodeRecord.`MUTATION_ID`)
SET n.`sample_name` = nodeRecord.`Sample Name`
SET n.`sample_id` = toInteger(trim(nodeRecord.`Sample ID`))
SET n.`gene_symbol` = nodeRecord.`Gene Name`
SET n.`transcript` = nodeRecord.`Transcript`
SET n.`census_gene` = nodeRecord.`Census Gene`
SET n.`drug_name` = nodeRecord.`Drug Name`
SET n.`genomic_mutation_id` = nodeRecord.`GENOMIC_MUTATION_ID`
SET n.`legacy_mutation_id` = nodeRecord.`LEGACY_MUTATION_ID`
SET n.`aa_mutation` = nodeRecord.`AA Mutation`
SET n.`cds_mutation` = nodeRecord.`CDS Mutation`
SET n.`primary_tissue` = nodeRecord.`Primary Tissue`
SET n.`pub_id` = toInteger(trim(nodeRecord.`Pubmed Id`))
SET n.`cgp_study` = nodeRecord.`CGP Study`
SET n.`somatic_status` = nodeRecord.`Somatic Status`
SET n.`sample_type` = nodeRecord.`Sample Type`
SET n.`zygosity` = nodeRecord.`Zygosity`
SET n.`genome_coordinates_grch38` = nodeRecord.`Genome Coordinates (GRCh38)`
SET n.`tier` = toInteger(trim(nodeRecord.`Tier`))
SET n.`HGVSP` = nodeRecord.`HGVSP`
SET n.`HGVSC` = nodeRecord.`HGVSC`
SET n.`HGVSG` = nodeRecord.`HGVSG`;
',
{batchSize:4000, iterateList:true, parallel:true});

// CosmicHallmark
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/Cancer_Gene_Census_Hallmarks_Of_Cancer.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`GENE_NAME`)) IS NULL
MERGE (n: `CosmicGeneHallmark` { `hallmark_id`: toInteger(lineNo) })
SET n.`gene_symbol` = nodeRecord.`GENE_NAME`
SET n.`cell_type` = nodeRecord.`CELL_TYPE`
SET n.`pub_id` = toInteger(trim(nodeRecord.`PUBMED_PMID`))
SET n.`hallmark` = nodeRecord.`HALLMARK`
SET n.`impact` = nodeRecord.`IMPACT`
SET n.`description` = nodeRecord.`DESCRIPTION`
',
{batchSize:4000, iterateList:true, parallel:true});

// SynMIC
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/SpecializedCancerDatasets/SynMICdb/SynMICdb.csv", { header:true}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  NOT (trim(nodeRecord.`Gene Name`)) IS NULL
MERGE (n: `SynMIC` { `synmic_id`: toInteger(lineNo) })
SET n.`gene_symbol` = nodeRecord.`Gene Name`
SET n.`transcript_id` = nodeRecord.`Transcript ID`
SET n.`mutation_id` = nodeRecord.`Mutation ID`
SET n.`mutation_nt` = nodeRecord.`Mutation nt`
SET n.`Mutation aa` = nodeRecord.`Mutation aa`
SET n.`mutation_genome_position` = nodeRecord.`Mutation Genome Position`
SET n.`chromosome` = nodeRecord.`Chromosome`
SET n.`start` = nodeRecord.`Start`
SET n.`end` = nodeRecord.`End`
SET n.`strand` = nodeRecord.`Strand`
SET n.`signature-normalized_frequency` = toFloat(trim(nodeRecord.`Signature-normalized Frequency`))
SET n.`average_mutation_load` = toInteger(trim(nodeRecord.`Average Mutation Load`))
SET n.`alternative_events` = nodeRecord.`Alternative Events`
SET n.`SNP` = nodeRecord.`SNP`
SET n.`conservation` = nodeRecord.`Conservation`
SET n.`structure_change_score_(remuRNA)` = nodeRecord.`Structure Change Score (remuRNA)`
SET n.`structure_change_score_((RNAsnp)` = nodeRecord.`Structure Change Significance (RNAsnp)`
SET n.`synmicdb_score` = nodeRecord.`SynMICdb Score`
SET n.`sample_name` = nodeRecord.`Sample ID`
SET n.`organ_sytem` = nodeRecord.`Organ System`
SET n.`site` = nodeRecord.`Site`
SET n.`histology` = nodeRecord.`Histology`
SET n.`mutation_load_sample` = toInteger(trim(nodeRecord.`Mutation Load Sample`))
SET n.`position_in_cds` = toFloat(trim(nodeRecord.`Position in CDS`))
SET n.`gcg_gene` = trim(nodeRecord.`CGC Gene`)
SET n.`exon_type` = nodeRecord.`Exon Type`
SET n.`distance_to_closest_exon_boundary` = nodeRecord.`Distance to Closest Exon Boundary`
SET n.`ese_gain_(RegRNA 2.0)` = nodeRecord.`ESE Gain (RegRNA 2.0)`
SET n.`ese_loss_(RegRNA 2.0)` = nodeRecord.`ESE Loss (RegRNA 2.0)`
SET n.`ess_gain_(RegRNA 2.0)` = nodeRecord.`ESS Gain (RegRNA 2.0)`
SET n.`ess_loss_(RegRNA 2.0)` = nodeRecord.`ESS Loss (RegRNA 2.0)`
SET n.`ese_gain_(SpliceAidF)` = nodeRecord.`ESE Gain (SpliceAidF)`
SET n.`ese_loss_(SpliceAidF)` = nodeRecord.`ESE Loss (SpliceAidF)`
SET n.`ess_gain_(SpliceAidF)` = nodeRecord.`ESS Gain (SpliceAidF)`
SET n.`ess_loss_(SpliceAidF)` = nodeRecord.`ESS Loss (SpliceAidF)`
SET n.`ese_&&ess_gain_(SpliceAidF)` = nodeRecord.`ESE & ESS Gain (SpliceAidF)`
SET n.`ese_&_ess_loss_(SpliceAidF)` = nodeRecord.`ESE & ESS Loss (SpliceAidF)`
SET n.`any_ese/ess_change` = nodeRecord.`Any ESE/ESS Change`;
',
{batchSize:4000, iterateList:true, parallel:true});


// ALSCancer ATlas
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/SpecializedCancerDatasets/ASCancerAtlas/ASCancer_Gene_All.csv", { header:true}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  NOT (trim(nodeRecord.`gene_name`)) IS NULL
MERGE (n: `AltSpliceCancer` { `id`: nodeRecord.`id` })
SET n.`has_oncoprint` = nodeRecord.`has_oncoprint`
SET n.`event_id` = nodeRecord.`event_id`
SET n.`as_model_id` = nodeRecord.`as_model_id`
SET n.`cancer_name` = nodeRecord.`cancer_name`
SET n.`tcga_project_id` = nodeRecord.`tcga_project_id`
SET n.`gene_symbol` = nodeRecord.`gene_name`
SET n.`hgnc_id` = toInteger(trim(nodeRecord.`hgnc_id`))
SET n.`ensembl_id` = nodeRecord.`ensembl_id`
SET n.`chr` = nodeRecord.`chr`
SET n.`strand` = nodeRecord.`strand`
SET n.`canonical_transcript_id` = nodeRecord.`canonical_transcript_id`
SET n.`ct_ensembl_id` = nodeRecord.`ct_ensembl_id`
SET n.`ct_refSeq_id` = nodeRecord.`ct_refSeq_id`
SET n.`canonical_transcript_description` = nodeRecord.`canonical_transcript_description`
SET n.`splice_variant_id` = nodeRecord.`splice_variant_id`
SET n.`sv_ensembl_id` = nodeRecord.`sv_ensembl_id`
SET n.`sv_refSeq_id` = nodeRecord.`sv_refSeq_id`
SET n.`splice_variant_description` = nodeRecord.`splice_variant_description`
SET n.`as_type` = nodeRecord.`as_type`
SET n.`related_exons` = nodeRecord.`related_exons`
SET n.`exon_ensembl_id` = nodeRecord.`exon_ensembl_id`
SET n.`event_coordinates` = nodeRecord.`event_coordinates`
SET n.`alt_coordinates` = nodeRecord.`alt_coordinates`
SET n.`splice_in_isoforms` = nodeRecord.`splice_in_isoforms`
SET n.`splice_out_isoforms` = nodeRecord.`splice_out_isoforms`
SET n.`orf_annotation` = nodeRecord.`orf_annotation`
SET n.`primer_f` = nodeRecord.`primer_f`
SET n.`primer_r` = nodeRecord.`primer_r`
SET n.`cell_line` = nodeRecord.`cell_line`
SET n.`primary_site` = nodeRecord.`primary_site`
SET n.`samples` = nodeRecord.`samples`
SET n.`methods` = nodeRecord.`methods`
SET n.`external_intervention` = nodeRecord.`external_intervention`
SET n.`regulatory_mechanism` = nodeRecord.`regulatory_mechanism`
SET n.`regulatory_gene` = nodeRecord.`regulatory_gene`
SET n.`biological_function` = nodeRecord.`biological_function`
SET n.`functional_description` = nodeRecord.`functional_description`
SET n.`year` = toInteger(trim(nodeRecord.`year`))
SET n.`pub_id` = toInteger(trim(nodeRecord.`pubmed_id`))
SET n.`journal` = nodeRecord.`journal`
SET n.`title` = nodeRecord.`title`;
',
{batchSize:4000, iterateList:true, parallel:true});

//HGNC
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/GenomicCoreData/HGNC/hgnc_complete_set.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`hgnc_id`)) IS NULL
MERGE (n: `HGNC` { `hgnc_id`: toInteger(trim(nodeRecord.`hgnc_id`)) })
SET n.`gene_symbol` = nodeRecord.`symbol`
SET n.`name` = nodeRecord.`name`
SET n.`locus_group` = nodeRecord.`locus_group`
SET n.`locus_type` = nodeRecord.`locus_type`
SET n.`status` = nodeRecord.`status`
SET n.`location` = nodeRecord.`location`
SET n.`location_sortable` = nodeRecord.`location_sortable`
SET n.`alias_symbols` = COALESCE(split(nodeRecord.`alias_symbol`,"|")," "),
SET n.`alias_names` = COALESCE(split(nodeRecord.`alias_name`,"|")," ")
SET n.`prev_symbols` = COALESCE(split(nodeRecord.`prev_symbol`,"|")," ")
SET n.`prev_name` = nodeRecord.`prev_name`
SET n.`gene_group` = nodeRecord.`gene_group`
SET n.`gene_group_id` = nodeRecord.`gene_group_id`
SET n.`date_approved_reserved` = datetime(nodeRecord.`date_approved_reserved`)
SET n.`date_symbol_changed` = datetime(nodeRecord.`date_symbol_changed`)
SET n.`date_name_changed` = datetime(nodeRecord.`date_name_changed`)
SET n.`date_modified` = datetime(nodeRecord.`date_modified`)
SET n.`entrez_id` = toInteger(trim(nodeRecord.`entrez_id`))
SET n.`ensembl_gene_id` = nodeRecord.`ensembl_gene_id`
SET n.`vega_id` = nodeRecord.`vega_id`
SET n.`ucsc_id` = nodeRecord.`ucsc_id`
SET n.`ena` = nodeRecord.`ena`
SET n.`refseq_accession` = nodeRecord.`refseq_accession`
SET n.`ccds_ids` =  COALESCE(split(nodeRecord.`ccds_id`,"|")," ")
SET n.`uniprot_ids` = COALESCE(split(nodeRecord.`uniprot_ids`,"|")," ")
SET n.`pub_ids` = COALESCE(split(nodeRecord.`pubmed_id`,"|")," ")
SET n.`mgd_id` = nodeRecord.`mgd_id`
SET n.`rgd_id` = nodeRecord.`rgd_id`
SET n.`lsdb` = nodeRecord.`lsdb`
SET n.`cosmic` = nodeRecord.`cosmic`
SET n.`omim_id` = toInteger(trim(nodeRecord.`omim_id`))
SET n.`mirbase` = nodeRecord.`mirbase`
SET n.`homeodb` = nodeRecord.`homeodb`
SET n.`snornabase` = nodeRecord.`snornabase`
SET n.`bioparadigms_slc` = COALESCE(split(nodeRecord.`bioparadigms`,"|")," ")
SET n.`orphanet` = toInteger(trim(nodeRecord.`orphanet`))
SET n.`pseudogene.org` = nodeRecord.`pseudogene.org`
SET n.`horde_id` = nodeRecord.`horde_id`
SET n.`merops` = nodeRecord.`merops`
SET n.`imgt` = nodeRecord.`imgt`
SET n.`iuphar` = nodeRecord.`iuphar`
SET n.`kznf_gene_catalog` = nodeRecord.`kznf_gene_catalog`
SET n.`mamit-trnadb` = nodeRecord.`mamit-trnadb`
SET n.`cd` = nodeRecord.`cd`
SET n.`lncrnadb` = nodeRecord.`lncrnadb`
SET n.`enzyme_ids` = COALESCE(split(nodeRecord.`enzyme_id`,"|")," ")
SET n.`intermediate_filament_db` = nodeRecord.`intermediate_filament_db`
SET n.`rna_central_ids` = COALESCE(split(nodeRecord.`rna_central_ids`,"|")," ")
SET n.`lncipedia` = nodeRecord.`lncipedia`
SET n.`gtrnadb` = nodeRecord.`gtrnadb`
SET n.`agr` = toInteger(trim(nodeRecord.`agr`))
SET n.`mane_select` = nodeRecord.`mane_select`
SET n.`gencc` = toInteger(trim(nodeRecord.`gencc`));
',
{batchSize:4000, iterateList:true, parallel:true});

// CosmicBreakPointMutation
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicBreakpointsExport.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`ID_SAMPLE`)) IS NULL
MERGE (n: `CosmicBreakpointMutation` { `mutation_id` = toInteger(trim(nodeRecord.`Mutation ID`)) })
SET n.`sample_id`: toInteger(trim(nodeRecord.`ID_SAMPLE`))
SET n.`sample_name` = nodeRecord.`Sample name`
SET n.`tumor_id` = toInteger(trim(nodeRecord.`ID_TUMOUR`))
SET n.`mutation_type` = nodeRecord.`Mutation Type`
SET n.`breakpoint_order` = nodeRecord.`Breakpoint Order`
SET n.`GRCh` = toInteger(trim(nodeRecord.`GRCh`))
SET n.`chrom_from` = nodeRecord.`Chrom From`
SET n.`location_from_min` = toInteger(trim(nodeRecord.`Location From min`))
SET n.`location_from_max` = toInteger(trim(nodeRecord.`Location From max`))
SET n.`strand_from` = nodeRecord.`Strand From`
SET n.`chrom_to` = tnodeRecord.`Chrom To`
SET n.`location_to_min` = toInteger(trim(nodeRecord.`Location To min`))
SET n.`location_to_max` = toInteger(trim(nodeRecord.`Location To max`))
SET n.`strand_to` = nodeRecord.`Strand To`
SET n.`non-templated_ins_seq` = nodeRecord.`Non-templated ins seq`
SET n.`pub_id` = nodeRecord.`Pubmed_PMID`;
',
{batchSize:4000, iterateList:true, parallel:true});

// CosmicCMC
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CMC/cmc_export.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
MERGE (cmc:CosmicCMC {legacy_mutation_id:nodeRecord.LEGACY_MUTATION_ID})
SET cmc.gene_symbol = nodeRecord.GENE_NAME,
  cmc.accession_number = nodeRecord.ACCESSION_NUMBER,
  cmc.onc_tsg = nodeRecord.ONC_TSG,
  cmc.cgc_tier = toInteger(nodeRecord.CGC_TIER),
  cmc.mutation_url = nodeRecord.MUTATION_URL,
  cmc.muation_cds = nodeRecord.`Mutation CDS`,
  cmc.mutation_aa = nodeRecord.`Mutation AA`,
  cmc.aa_mut_start = toInteger(nodeRecord.AA_MUT_START),
  cmc.aa_mut_stop = toInteger(nodeRecord.AA_MUT_STOP),
  cmc.shared_aa = nodeRecord.SHARED_AA,
  cmc.genomic_wt_allele_seq = nodeRecord.GENOMIC_WT_ALLELE_SEQ,
  cmc.genomic_mut_allele_seq= nodeRecord.GENOMIC_MUT_ALLELE_SEQ,
  cmc.aa_wt_allele_seq = nodeRecord.AA_WT_ALLELE_SEQ,
  cmc.aa_mut_allele_seq = nodeRecord.AA_MUT_ALLELE_SEQ,
  cmc.mutation_description_cds = nodeRecord.`Mutation Description CDS`,
  cmc.mutation_description_aa = nodeRecord.`Mutation Description AA`,
  cmc.ontology_mutation_code = nodeRecord.ONTOLOGY_MUTATION_CODE,
  cmc.genomic_mutation_id = nodeRecord.GENOMIC_MUTATION_ID,
  cmc.mutation_genome_position_grch37 = nodeRecord.`Mutation genome position GRCh37`,
  cmc.mutation_genome_position_grch38 = nodeRecord.`Mutation genome position GRCh38`,
  cmc.cosmic_sample_tested = toInteger(nodeRecord.COSMIC_SAMPLE_TESTED),
  cmc.cosmic_sample_mutated = toInteger(nodeRecord.COSMIC_SAMPLE_MUTATED),
  cmc.disease = nodeRecord.DISEASE,
  cmc.wgs_disease = nodeRecord.WHS_DISEASE
',
{batchSize:4000, iterateList:true, parallel:true});



// CosmicActionability
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/ActionabilityData.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
MERGE (action:CosmicActionability {actionability_id:toInteger(lineNo)})
SET action.gene_symbol=nodeRecord.GENE,
  action.mutation_remark=nodeRecord.MUTATION_REMARK,
  action.genomic_mutation_id=nodeRecord.GENOMIC_MUTATION_ID,
  action.fusion_id=nodeRecord.FUSION_ID,
  action.mutation_aa_syntax=nodeRecord.MUTATION_AA_SYNTAX,
  action.disease=nodeRecord.DISEASE,
  action.actionability_rank=toInteger(nodeRecord.ACTIONABILITY_RANK),
  action.development_status=nodeRecord.DEVELOPMENT_STATUS,
  action.drug_combination=nodeRecord.DRUG_COMBINATION,
  action.testing_required=nodeRecord.TESTING_REQUIRED,
  action.trial_status=nodeRecord.TRIAL_STATUS,
  action.trial_id=nodeRecord.TRIAL_ID,
  action.completion_status=nodeRecord.COMPLETION_STATUS,
  action.trial_completion_date=nodeRecord.RIAL_PRIMARY_COMPLETION_DATE,
  action.patient_prescreening=nodeRecord.PATIENT_PRESCREENING,
  action.results_availability=nodeRecord.RESULTS_AVAILABILITY,
  action.progression_remark=nodeRecord.PROGRESSION_REMARK,
  action.source_type=nodeRecord.SOURCE_TYPE,
  action.source=nodeRecord.SOURCE,
  action.treatment_history=nodeRecord.TREATMENT_HISTORY,
  action.patient_age=toInteger(nodeRecord.PATIENT_AGE),
  action.primary_outcome_measure=nodeRecord.PRIMARY_OUTCOME_MEASURE,
  action.number_of_patients=toInteger(nodeRecord.NUMBER_OF_PATIENTS),
  action.treated_number=toInteger(nodeRecord.TREATED_NUMBER),
  action.control_number=toInteger(CONTROL_NUMBER),
  action.control_treatment=nodeRecord.CONTROL_TREATMENT,
  action.orr_treat=toFloat(nodeRecord.ORR_TREAT),
  action.orr_con=toFloat(nodeRecord.ORR_CON),
  action.orr_ci=nodeRecord.ORR_CI,
  action.orr_pval=nodeRecord.ORR_PVAL,  // persist as String; may have < sign
  action.dor_treat=toFloat(nodeRecord.DOR_TREAT),
  action.dor_con=toFloat(nodeRecord.DOR_CON),
  action.dor_ci=toFloat(nodeRecord.DOR_CI),
  action.dor_pval=nodeRecord.DOR_PVAL,  // persist as String; may have < sign
  action.pfs_treat=toFloat(nodeRecord.PFS_TREAT),
  action.pfs_con=toFloat(nodeRecord.PFS_CON),
  action.pfs_ci=nodeRecord.PFS_CI,
  action.pfs_pval=nodeRecord.PFS_PVAL, // persist as String; may have < sign
  action.ttp_treat=toFloat(nodeRecord.TTP_TREAT),
  action.ttp_con=toFloat(nodeRecord.TTP_CON),
  action.ttp_hr=nodeRecord.TTP_HR,
  action.ttp_ci=nodeRecord.TTP_CI,
  action.ttp_pval=nodeRecord.TTP_PVAL, // persist as String; may have < sign
  action.dcr_treat=toFloat(nodeRecord.DCR_TREAT),
  action.dcr_con=toFloat(nodeRecord.DCR_CON),
  action.dcr_pval=nodeRecord.DCR_PVAL, // persist as String; may have < sign
  action.os_treat=toFloat(nodeRecord.OS_TREAT),
  action.os_con=toFloat(nodeRecord.OS_CON),
  action.os_hr=nodeRecord.OS_HR,
  action.os_ci=nodeRecord.OS_CI,
  action.os_pval=nodeRecord.OS_PVAL,
  action.obj_rr_treat=nodeRecord.OBJ_RR_TREAT,
  action.cr_count=toInteger(nodeRecord.CR_COUNT),
  action.pr_count=toInteger(nodeRecord.PR_COUNT),
  action.sd_count=toInteger(nodeRecord.SD_COUNT),
  action.rfs_treat=toFloat(nodeRecord.RFS_TREAT),
  action.rfs_con=toFloat(nodeRecord.RFS_CON),
  action.rfs_hr=nodeRecord.RFS_HR,
  action.rfs_ci=nodeRecord.RFS_CI,
  action.rfs_pval=nodeRecord.RFS_PVAL,
  action.blood_response=nodeRecord.BLOOD_RESPONSE,
  action.response_value=nodeRecord.RESPONSE_VALUE,
  action.timepoinr=nodeRecord.TIMEPOINT,
  action.classification_id=nodeRecord.CLASSIFICATION_ID,
  action.last_update=nodeRecord.LAST_UPDATED
',
{batchSize:4000, iterateList:true, parallel:true});

// CosmicMutationTracking
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicMutationTracking.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
MERGE (track:CosmicMutationTracking {mutation_id:toInteger(nodeRecord.MUTATION_ID)})
SET track.gene_symbol = nodeRecord.GENE_NAME,
  track.accession_number = nodeRecord.ACCESSION_NUMBER,
  track.genomic_mutation_id = nodeRecord.GENOMIC_MUTATION_ID,
  track.legacy_mutation_id = nodeRecord.LEGACY_MUTATION_ID,
  track.GRCh = nodeRecord.GRCH,
  track.mutation_type = nodeRecord.MUTATION_TYPE,
  track.is_canonical = toUpper(nodeRecord.IS_CANONICAL)
',
{batchSize:4000, iterateList:true, parallel:true});

// add clinical trials URL property
CALL {
MATCH(act:CosmicActionability) WHERE act.trial_id IS NOT NULL
SET act.drug_trial_url = replace("https://clinicaltrials.gov/ct2/show/XXXX","XXXX", act.trial_id)
} IN TRANSACTIONS OF 1000 ROWS;

// Patient to Tumor relationship
CALL {
MATCH(source:CosmicPatient)
  WHERE source.individual_id IS NOT NULL
MATCH(target:CosmicTumor)
  WHERE target.individual_id = source.individual_id
MERGE (source)-[r:`HAS_TUMOR`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// Tumor to Sample relationship
CALL {
MATCH (source:CosmicTumor) WHERE source.tumor_id IS NOT NULL
MATCH (target:CosmicSample) WHERE target.tumor_id = source.tumor_id
MERGE (source)-[r: `HAS_SAMPLE`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// Sample to Sample Classification relationship
CALL {
MATCH(source:CosmicSample)
  WHERE source.`cosmic_phenotype_id`
MATCH(target:CosmicSampleClassification)
  WHERE target.`cosmic_phenotype_id` = source.`cosmic_phenotype_id`
MERGE (source)-[r:`HAS_CLASSIFICATION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGene to CosmicGeneMutationCollection relationship
CALL {
MATCH (source:`CosmicGene`)
MATCH (target: `CosmicGeneMutationCollection`) WHERE source.gene_symbol = target.gene_symbol
MERGE (source)-[r: `HAS_GENE_MUTATION_COLLECTION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGeneMutationCollection to CosmicMutation relationship
CALL {
MATCH (source: `CosmicGeneMutationCollection` )
MATCH (target: `CosmicMutation`) WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r: `HAS_MUTATION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicSample to CosmicSampleMutationCollection relationship
CALL {
MATCH (source:CosmicSample)
MATCH (target:CosmicSampleMutationCollection) WHERE target.sample_id = source.sample_id
MERGE (source)-[r: `HAS_SAMPLE_MUTATION_COLLECTION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicSampleMutationCollection to CosmicStructuralMutation relationship
CALL {
MATCH  (source:CosmicSampleMutationCollection)
MATCH (target:CosmicStucturalMutation)  WHERE target.sample_id = source.sample_id
MERGE (source)-[r: `HAS_STRUCTURAL_MUTATION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicSampleMutationCollection to CosmicMutation relationship
CALL {
MATCH (source: `CosmicSampleMutationCollection`)
MATCH (target: `CosmicMutation`) WHERE target_.sample_id = source.sample_id
MERGE (source)-[r: `HAS_MUTATION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicSampleMutationCollection to CosmicResistanceMutation relationship
CALL {
MATCH (source: `CosmicSampleMutationCollection`)
MATCH (target: `CosmicResistanceMutation`) WHERE target.sample_id = source.sample_id
MERGE (source)-[r: `HAS_RESISTANCE_MUTATION`]->(target);
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGeneMutationCollection to CosmicResistanceMutation
CALL {
MATCH (source: `CosmicGeneMutationCollection`)
MATCH (target: `CosmicResistanceMutation`) WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r: `HAS_RESISTANCE_MUTATION`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGeneMutationCollection to CosmicStructuralMutation relationship
CALL {
MATCH (source:`CosmicGeneMutationCollection`)
MATCH(target:`CosmicStucturalMutation`)
  WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r:`HAS_STRUCTURAL_MUTATION`]->(target);
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGeneMutationCollection to CosmicStructuralMuttaion
CALL {
MATCH (source:`CosmicGeneMutationCollection`)
MATCH(target:`SynMIC`)
  WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r:`HAS_SYNONYMOUS_MUTATION`]->(target);
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGene to AltSpliceCancer relationship
CALL  {
MATCH (source: `CosmicGene`)
MATCH (target: `AltSpliceCancer`) WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r: `HAS_ALTERNATE_SPLICING`]->(target);
} IN TRANSACTIONS OF 1000 ROWS;

// AltSpliceCancer to HGNC relationship
CALL {
MATCH (source: `AltSpliceCancer` ) WHERE source.hgnc_id IS NOT NULL
MATCH (target: `HGNC`) WHERE target.hgnc_id = source.hgnc_id
MERGE (source)-[r: `HAS_HGNC`]->(target)
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGene to HGNC relationship (too small for batching)
UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGene`)
MATCH (target: `HGNC`) WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r: `HAS_HGNC`]->(target);

// CosmicSampleMutationCollection to CosmicBreakpointMutation
CALL {
MATCH (source: `CosmicSampleMutationCollection`)
MATCH (target: `CosmicBreakPointMutation`) WHERE target.sample_id = source.sample_id
MERGE (source)-[r: `HAS_BREAKPOINT_MUTATION`]->(target);
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicGeneMutationCollection to CosmicBreakpointMutation
CALL {
MATCH (source: `CosmicGeneMutationCollection` )
MATCH (target: `CosmicBreakPointMutation`) WHERE target.gene_symbol = source.gene_symbol
MERGE (source)-[r: `HAS_BREAKPOINT_MUTATION`]->(target);
} IN TRANSACTIONS OF 1000 ROWS;

// CosmicClassification to CosmicActionability
CALL {
MATCH (act:CosmicActionability) WHERE act.classification_id IS NOT NULL
MATCH (clas:CosmicClassification) WHERE class.phenotype_id = act.classification_id
MERGE (class)-[r:HAS_ACTIONAVAILABILY]->(act)
}IN TRANSACTIONS OF 1000 ROWS;

// CosmicGeneMutationCollection to CosmicCMC relationship
CALL {
MATCH (cmc:CosmicCMC) WHERE cmc.gene_symbol IS NOT NULL
MATCH (gmc:GeneMutationCollection) WHERE gmc.gene_symbol = cmc.gene_symbol
MERGE (gmc) -[r1:HAS_CODING_MUTATION]->(cmc)
}IN TRANSACTIONS OF 1000 ROWS;

// CosmicMutation to CosmicMutationTracking Relationship
CALL {
MATCH (track:CosmicMutationTracking) WHERE track.mutation_id IS NOT NULL
MATCH (mut:CosmicMutation) WHERE mut.mutation_id = track.mutation_id
MERGE (mut)-[r1:HAS_MUTATION_TRACKING]->(track)
}IN TRANSACTIONS OF 1000 ROWS;

// Add Publication nodes and relationships
// CosmicBreakpoint publications
CALL {
MATCH(break:CosmicBreakpoint) WHERE break.pub_id IS NOT NULL
MERGE(p:Publication{ pub_id:toInteger(break.pub_id)})
SET p.url= genomiccore.resolvePubmedUrl(break.pub_id)
MERGE (break)-[r2:HAS_PUBLICATION]->(p)
}IN TRANSACTIONS OF 1000 ROWS;

// CosmicMutation publications
CALL {
MATCH (ccm:CosmicMutation) WHERE ccm.pub_id IS NOT NULL
MERGE(p:Publication{ pub_id:ccm.pub_id})
SET p.url= genomiccore.resolvePubmedUrl(toString(ccm.pub_id))
MERGE (ccm)-[HAS_PUBLICATION]->(p)
}IN TRANSACTIONS OF 1000 ROWS;

// CosmicResistantMutation publications
CALL {
MATCH(resist:CosmicResistanceMutation) WHERE resist.pub_id IS NOT NULL
MERGE(p:Publication{ pub_id:toInteger(resist.pub_id)})
SET p.url= genomiccore.resolvePubmedUrl(resist.pub_id)
MERGE (resist)-[r1:HAS_PUBLICATION]->(p)
}IN TRANSACTIONS OF 1000 ROWS;

// CosmicHallmark publications
CALL {
MATCH(hallmark:CosmicHallmark) WHERE hallmark.pub_id IS NOT NULL
MERGE(p:Publication{ pub_id:toInteger(hallmark.pub_id)})
SET p.url= genomiccore.resolvePubmedUrl(hallmark.pub_id)
MERGE (hallmark)-[r:HAS_PUBLICATION]->(p)
}IN TRANSACTIONS OF 1000 ROWS;





















































