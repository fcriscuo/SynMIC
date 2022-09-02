package org.batteryparkdev.synmic.dao

import org.batteryparkdev.genomicgraphcore.common.CoreModel
import org.batteryparkdev.genomicgraphcore.common.CoreModelDao
import org.batteryparkdev.genomicgraphcore.common.formatNeo4jPropertyValue
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.NodeIdentifier
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.NodeIdentifierDao
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.RelationshipDefinition
import org.batteryparkdev.synmic.model.RegRNA
import org.batteryparkdev.synmic.model.SpliceAidF
import org.batteryparkdev.synmic.model.SynMutation

class SynMutationDao( private val synmut: SynMutation) {

    fun generateSynMutationCypher(): String = mergeNewNodeCypher(synmut)
        .plus(" RETURN ${SynMutation.nodename}")

    private fun mergeNewNodeCypher(synmut: SynMutation): String = "CALL apoc.merge.node( [\"SynonymousMutation\"], " +
            " {key: ${synmut.key}, " +
            "{ gene_name: ${synmut.geneName.formatNeo4jPropertyValue()}, " +
            " transcript_id: ${synmut.transcriptId.formatNeo4jPropertyValue()}," +
            " mutation_id: ${synmut.mutationId.formatNeo4jPropertyValue()}," +
            " nt_mutation: ${synmut.ntMutation.formatNeo4jPropertyValue()}, " +
            " aa_mutation: ${synmut.aaMutation.formatNeo4jPropertyValue()}, " +
            " mutation_genome_position: ${synmut.mutationGenomePosition.formatNeo4jPropertyValue()}, " +
            " chromosome: ${synmut.chromosome.formatNeo4jPropertyValue()}, " +
            " mutation_start: ${synmut.mutationStart}, mutation_end: ${synmut.mutationEnd}, " +
            " signature_normalized_frequency: ${synmut.signatureNormalizedFrequency}, " +
            " avg_mutation_load: ${synmut.avgMutationLoad}, " +
            " alternative_events: ${synmut.alternativeEvents.formatNeo4jPropertyValue()}, " +
            " snp: ${synmut.snp.formatNeo4jPropertyValue()}, " +
            " conservation: ${synmut.conservation.formatNeo4jPropertyValue()}, " +
            " structure_change_score: ${synmut.structureChangeScore.formatNeo4jPropertyValue()}, " +
            " structure_change_significance: ${synmut.structureChangeSignificance.formatNeo4jPropertyValue()}," +
            " synmicdb_score: ${synmut.synmicdbScore} sample_id: ${synmut.sampleId.formatNeo4jPropertyValue()}, " +
            " organ_system: ${synmut.organSystem.formatNeo4jPropertyValue()}, " +
            " site: ${synmut.site.formatNeo4jPropertyValue()}, histology: ${synmut.histology.formatNeo4jPropertyValue()}, " +
            " mutation_load_sample: ${synmut.mutationLoadSample}, position_in cds: ${synmut.positionInCDS}, " +
            " cgc_gene: ${synmut.cgcGene}, exon_type: ${synmut.exonType.formatNeo4jPropertyValue()}, " +
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
            model.getModelGeneSymbol())
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




