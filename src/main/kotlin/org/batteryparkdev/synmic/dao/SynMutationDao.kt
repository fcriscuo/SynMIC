package org.batteryparkdev.synmic.dao

import org.batteryparkdev.genomicgraphcore.common.CoreModel
import org.batteryparkdev.genomicgraphcore.common.CoreModelDao
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.NodeIdentifier
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.NodeIdentifierDao
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.RelationshipDefinition
import org.batteryparkdev.synmic.model.RegRNA
import org.batteryparkdev.synmic.model.SpliceAidF
import org.batteryparkdev.synmic.model.SynMutation

class SynMutationDao( private val synmut: SynMutation) {

    fun generateSynMutationCypher(): String = mergeNewNodeCypher(synmut)
        .plus(" RETURN ${SynMutation.nodename}")
 // n.b String property values in this model are already in double quotes
    private fun mergeNewNodeCypher(synmut: SynMutation): String = "CALL apoc.merge.node( [\"SynonymousMutation\"], " +
            " {key: ${synmut.key}} , " +
            "{ gene_name: ${synmut.geneName}, " +
            " transcript_id: ${synmut.transcriptId}," +
            " mutation_id: ${synmut.mutationId}," +
            " nt_mutation: ${synmut.ntMutation}, " +
            " aa_mutation: ${synmut.aaMutation}, " +
            " mutation_genome_position: ${synmut.mutationGenomePosition}, " +
            " chromosome: ${synmut.chromosome}, " +
            " mutation_start: ${synmut.mutationStart}, mutation_end: ${synmut.mutationEnd}, " +
            " signature_normalized_frequency: ${synmut.signatureNormalizedFrequency}, " +
            " avg_mutation_load: ${synmut.avgMutationLoad}, " +
            " alternative_events: ${synmut.alternativeEvents}, " +
            " snp: ${synmut.snp}, " +
            " conservation: ${synmut.conservation}, " +
            " structure_change_score: ${synmut.structureChangeScore}, " +
            " structure_change_significance: ${synmut.structureChangeSignificance}," +
            " synmicdb_score: ${synmut.synmicdbScore}, sample_id: ${synmut.sampleId}, " +
            " organ_system: ${synmut.organSystem}, " +
            " site: ${synmut.site}, histology: ${synmut.histology}, " +
            " mutation_load_sample: ${synmut.mutationLoadSample}, position_in_cds: ${synmut.positionInCDS}, " +
            " cgc_gene: ${synmut.cgcGene}, exon_type: ${synmut.exonType}, " +
            " distance_to_exon_boundary: ${synmut.distanceToExonBoundary}, " +
            "any_ese_ess_change: ${synmut.anyEseEssChange}, "
                .plus(generateRegRNACypher(synmut.regRna))
                .plus(generateSpliceAdfCypher(synmut.spliceAidF))
                .plus(" created: datetime()},{}) YIELD node as ${SynMutation.nodename} \n")

    private fun generateSpliceAdfCypher(spliceAidF: SpliceAidF): String =
        "spliceaidf_ese_gain: ${spliceAidF.eseGain}, spliceaidf_ese_loss: ${spliceAidF.eseLoss}, " +
                " spiceaidf_ess_gain: ${spliceAidF.essGain}, spliceaidf_ess_loss: ${spliceAidF.essLoss}, " +
                " spliceaidf_ese_ess_gain: ${spliceAidF.eseAndEssGain}, " +
                " spliceaidf_ese_ess_loss: ${spliceAidF.eseAndEssLoss}, \n"

    private fun generateRegRNACypher(regrna: RegRNA): kotlin.String =
        " regrna_ese_gain: ${regrna.eseGain}, regrna_ese_loss: ${regrna.eseLoss}, " +
                " regrna_ess_gain: ${regrna.essGain}, regrna_ess_loss: ${regrna.essLoss}, \n"

    companion object: CoreModelDao{

        /*
      SynMutations have relationships to a GeneMutationCollection Node and a SampleMutationCollection node
       */
        fun completeRelationships(model: CoreModel) {
            completeGeneMutationCollectionRelationship(model)
            completeSampleCollectionRelationship(model)
        }

        private fun completeGeneMutationCollectionRelationship(model: CoreModel){
            val parentNode = NodeIdentifier("GeneMutationCollection", "gene_symbol",
            model.getModelGeneSymbol().replace("\"",""))
            NodeIdentifierDao.defineRelationship(RelationshipDefinition( parentNode
                , model.getNodeIdentifier(), "HAS_MUTATION"))
        }

        private fun completeSampleCollectionRelationship(model: CoreModel) {
            val parentNode = NodeIdentifier("SampleMutationCollection","sample_id",
            model.getModelSampleId())
            NodeIdentifierDao.defineRelationship(
                RelationshipDefinition(parentNode, model.getNodeIdentifier(),
             "HAS_MUTATION")
            )
        }

        override val modelRelationshipFunctions: (CoreModel) -> Unit
             = ::completeRelationships
    }
}




