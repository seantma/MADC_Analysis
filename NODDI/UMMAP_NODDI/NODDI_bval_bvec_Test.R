
# Reading `dcm2nii` derived bval/bvec files
bvec <- read.table('Desktop/s015a1001.bvec')
bvec_t <- t(bvec)

bval <- read.table('Desktop/s015a1001.bval')
bval_t <- t(bval)

camino <- cbind(bvec_t, bval_t)

# Scott's Camino scheme transform for UMMAP NODDI DTI bvec/bval
ummap <- read.table('Desktop/tmp.txt')

write.table(t(ummap$V4), 'Desktop/bval_test.txt', row.names = FALSE, col.names = FALSE)

ummap_bvec <- t(ummap[1:3])
write.table(ummap_bvec, 'Desktop/bvec_test.txt', row.names = FALSE, col.names = FALSE)

# Examine bval/bvec in AMICO NODDI Toolbox example data
amico_bvec <- read.table('~/Dropbox/2organize/NODDI_AMICO/NODDI_example_dataset/NODDI_protocol.bvec')
amico_bval <- read.table('~/Dropbox/2organize/NODDI_AMICO/NODDI_example_dataset/NODDI_protocol.bval')

amico_bvec_t <- t(amico_bvec)
amico_bval_t <- t(amico_bval)
