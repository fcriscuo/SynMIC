package org.batteryparkdev.synmic.model

import org.apache.commons.csv.CSVRecord
import org.batteryparkdev.cosmicgraphdb.model.AbstractModel
import org.batteryparkdev.cosmicgraphdb.model.CosmicCodingMutation
import org.batteryparkdev.cosmicgraphdb.model.CosmicModel
import org.batteryparkdev.neo4j.service.Neo4jConnectionService
import org.batteryparkdev.neo4j.service.Neo4jUtils
import org.batteryparkdev.nodeidentifier.model.NodeIdentifier

/*
CSV column headings:
"Gene Name","Transcript ID","Mutation ID","Mutation nt","Mutation aa","Mutation Genome Position",
"Chromosome","Start","End","Strand","Signature-normalized Frequency","Average Mutation Load",
"Alternative Events","SNP","Conservation","Structure Change Score (remuRNA)",
"Structure Change Significance (RNAsnp)","SynMICdb Score","Sample ID","Organ System",
"Site","Histology","Mutation Load Sample","Position in CDS","CGC Gene","Exon Type",
"Distance to Closest Exon Boundary","ESE Gain (RegRNA 2.0)","ESE Loss (RegRNA 2.0)",
"ESS Gain (RegRNA 2.0)","ESS Loss (RegRNA 2.0)","ESE Gain (SpliceAidF)","ESE Loss (SpliceAidF)",
"ESS Gain (SpliceAidF)","ESS Loss (SpliceAidF)","ESE & ESS Gain (SpliceAidF)",
"ESE & ESS Loss (SpliceAidF)","Any ESE/ESS Change"
*/


data class RegRNA(
    val eseGain: Int, val eseLoss: Int, val essGain: Int, val essLoss: Int
): CosmicModel{
    companion object:AbstractModel {
        fun parseCSVRecord(record: CSVRecord): RegRNA =
            RegRNA(
                parseValidIntegerFromString(record.get("ESE Gain (RegRNA 2.0)")),
                parseValidIntegerFromString(record.get("ESE Loss (RegRNA 2.0)")),
                parseValidIntegerFromString(record.get("ESS Gain (RegRNA 2.0)")),
                parseValidIntegerFromString(record.get("ESS Loss (RegRNA 2.0)"))
            )
    }

    override fun generateLoadCosmicModelCypher(): String =
        when (isValid()){
            true -> " regrna_ese_gain: $eseGain, regrna_ese_loss: $eseLoss, " +
                    " regrna_ess_gain: $essGain, regrna_ess_loss: $essLoss, "
            false -> " "
        }

    override fun getNodeIdentifier(): NodeIdentifier {
        TODO("Not yet implemented")
    }

    override fun getPubMedId(): Int = 0


    override fun isValid(): Boolean  =
        (eseGain + eseLoss + essGain + essLoss) > 0

}

data class SpliceAidF(
    val eseGain: Int, val eseLoss: Int, val essGain: Int, val essLoss: Int,
    val eseAndEssGain: Int, val eseAndEssLoss: Int
) : CosmicModel{
    companion object: AbstractModel {
        fun parseCSVRecord(record: CSVRecord): SpliceAidF =
            SpliceAidF(
                parseValidIntegerFromString(record.get("ESE Gain (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESE Loss (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESS Gain (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESS Loss (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESE & ESS Gain (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESE & ESS Loss (SpliceAidF)"))
            )
    }

    override fun generateLoadCosmicModelCypher(): String =
        when (isValid()) {
            true -> "spliceaidf_ese_gain: $eseGain, spliceaidf_ese_loss: $eseLoss, " +
                    " spiceaidf_ess_gain: $essGain, spliceaidf_ess_loss: $essLoss, " +
                    " spliceaidf_ese_ess_gain: $eseAndEssGain, " +
                    " spliceaidf_ese_ess_loss: $eseAndEssLoss, "
            false -> " "
        }

    override fun getNodeIdentifier(): NodeIdentifier {
        TODO("Not yet implemented")
    }

    override fun getPubMedId(): Int  = 0

    override fun isValid(): Boolean =
        ( eseGain + eseLoss + essGain + essLoss + eseAndEssGain + eseAndEssLoss) > 0
}

data class SynMutation(
    val key: Int,   // unique key
    val geneName: String, val transcriptId: String, val mutationId: String,
    val ntMutation: String, val aaMutation: String, val mutationGenomePosition: String,
    val chromosome: String, val mutationStart: Int, val mutationEnd: Int, val strand: String,
    val signatureNormalizedFrequency: Double, val avgMutationLoad: Int,
    val alternativeEvents: String, val snp: String, val conservation: String,
    val structureChangeScore: String, val structureChangeSignificance: String,
    val synmicdbScore: Double, val sampleId: String, val organSystem: String,
    val site: String, val histology: String, val mutationLoadSample: Int,
    val positionInCDS: Float, val cgcGene: Boolean, val exonType: String,
    val distanceToExonBoundary: Int, val regRna: RegRNA, val spliceAidF: SpliceAidF,
    val anyEseEssChange: Int
) : CosmicModel {

    override fun generateLoadCosmicModelCypher(): String = mergeNewNodeCypher
        .plus(generateGeneMutationCollectionRelationshipCypher(geneName, CosmicCodingMutation.nodename))
        .plus(generateSampleRelationship())
        .plus(" RETURN ${SynMutation.nodename}")

    override fun getNodeIdentifier(): NodeIdentifier = NodeIdentifier("SynonymousMutation","key",
    key.toString())


    override fun getPubMedId(): Int = 0

    override fun isValid(): Boolean =
        geneName.isNotEmpty().and(sampleId.isNotEmpty()).and(mutationId.isNotEmpty())
            .and(ntMutation.isNotEmpty())


    // The SynMICdb.csv file uses the heading "Sample ID" for what is really the sample name
    private fun generateSampleRelationship(): String {
        val sampleId =
            parseValidIntegerFromString(Neo4jConnectionService.executeCypherCommand(
                "MATCH (cs:CosmicSample{sample_name: "
                    .plus(Neo4jUtils.formatPropertyValue(sampleId))
                    .plus("}) RETURN cs.sample_id")
            ))
        return generateSampleMutationCollectionRelationshipCypher(sampleId, SynMutation.nodename)
    }

    private val mergeNewNodeCypher = "CALL apoc.merge.node( [\"SynonymousMutation\"], " +
            " {key: $key}, " +
            "{ gene_name: ${Neo4jUtils.formatPropertyValue(geneName)}, " +
            " transcript_id: ${Neo4jUtils.formatPropertyValue(transcriptId)}," +
            " mutation_id: ${Neo4jUtils.formatPropertyValue(mutationId)}," +
            " nt_mutation: ${Neo4jUtils.formatPropertyValue(ntMutation)}, " +
            " aa_mutation: ${Neo4jUtils.formatPropertyValue(aaMutation)}, " +
            " mutation_genome_position: ${Neo4jUtils.formatPropertyValue(mutationGenomePosition)}, " +
            " chromosome: ${Neo4jUtils.formatPropertyValue(chromosome)}, " +
            " mutation_start: $mutationStart, mutation_end: $mutationEnd, " +
            " signature_normalized_frequency: $signatureNormalizedFrequency, " +
            " avg_mutation_load: $avgMutationLoad, " +
            " alternative_events: ${Neo4jUtils.formatPropertyValue(alternativeEvents)}, " +
            " snp: ${Neo4jUtils.formatPropertyValue(snp)}, " +
            " conservation: ${Neo4jUtils.formatPropertyValue(conservation)}, " +
            " structure_change_score: ${Neo4jUtils.formatPropertyValue(structureChangeScore)}, " +
            " structure_change_significance: ${Neo4jUtils.formatPropertyValue(structureChangeSignificance)}," +
            " synmicdb_score: $synmicdbScore, sample_id: ${Neo4jUtils.formatPropertyValue(sampleId)}, " +
            " organ_system: ${Neo4jUtils.formatPropertyValue(organSystem)}, " +
            " site: ${Neo4jUtils.formatPropertyValue(site)}, histology: ${Neo4jUtils.formatPropertyValue(histology)}, " +
            " mutation_load_sample: $mutationLoadSample, position_in cds: $positionInCDS, " +
            " cgc_gene: $cgcGene, exon_type: ${Neo4jUtils.formatPropertyValue(exonType)}, " +
            " distance_to_exon_boundary: $distanceToExonBoundary, any_ese_ess_change: $anyEseEssChange, "
                .plus(regRna.generateLoadCosmicModelCypher())
                .plus(spliceAidF.generateLoadCosmicModelCypher())
                .plus(" created: datetime()},{}) YIELD node as ${SynMutation.nodename} \n")


    companion object : AbstractModel {
        val nodename = "synonymous_mutation"

        fun parseCSVRecord(record: CSVRecord): SynMutation =
            SynMutation(
                record.toString().hashCode(),
                record.get("Gene Name"),
                record.get("Transcript ID"),
                record.get("Mutation ID"),
                record.get("Mutation nt"),
                record.get("Mutation aa"),
                record.get("Mutation Genome Position"),
                record.get("Chromosome"),
                parseValidIntegerFromString(record.get("Start")),
                parseValidIntegerFromString(record.get("End")),
                record.get("Strand"),
                parseValidDoubleFromString(record.get("Signature-normalized Frequency")),
                parseValidIntegerFromString(record.get("Average Mutation Load")),
                record.get("Alternative Events"),
                record.get("SNP"),
                record.get("Conservation"),
                record.get("Structure Change Score (remuRNA)"),
                record.get("Structure Change Significance (RNAsnp)"),
                parseValidDoubleFromString(record.get("SynMICdb Score")),
                record.get("Sample ID"),
                record.get("Organ System"),
                record.get("Site"),
                record.get("Histology"),
                parseValidIntegerFromString(record.get("Mutation Load Sample")),
                parseValidFloatFromString(record.get("Position in CDS")),
                convertNumericToBoolean(record.get("CGC Gene")),
                record.get("Exon Type"),
                parseValidIntegerFromString(record.get("Distance to Closest Exon Boundary")),
                RegRNA.parseCSVRecord(record),
                SpliceAidF.parseCSVRecord(record),
                parseValidIntegerFromString(record.get("Any ESE/ESS Change"))
            )

        fun convertNumericToBoolean(value: String): Boolean = value == "1"
    }
}
