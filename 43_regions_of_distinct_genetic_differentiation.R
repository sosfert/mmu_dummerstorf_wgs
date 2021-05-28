library(dplyr)
library(stringr)

# Import window Fst data
win_fst_sel_vs_ctrl <- lapply(list.files(pattern = "windowed.weir.fst$"), function(fl){read.table(fl, header = T, stringsAsFactors = F)})

names(win_fst_sel_vs_ctrl) <- list.files(pattern = "windowed.weir.fst$") %>% str_remove(".windowed.weir.fst")

# Prepare Fst data
levs <- c("DUK_vs_FZTDU","DUC_vs_FZTDU","DU6_vs_FZTDU",
	  "DU6P_vs_FZTDU","DUhLB_vs_FZTDU","FERT_vs_FZTDU")
win_fst_sel_vs_ctrl_prep <- lapply(win_fst_sel_vs_ctrl, function(d){
	d %>% 
		# filter by min number of SNPs in window (min 10 SNPs)
		dplyr::filter(N_VARIANTS >= 10) %>% 
		# separate x chromosome
		mutate(is_x = CHROM == "X") %>% 
		# group by autosomes/chrX
		group_by(is_x) %>% 
		# compute zscores
		mutate(z_win_fst_score = scale(MEAN_FST))   
	}) %>%
	bind_rows(.id = "contrast") %>% 
	mutate(contrast = factor(contrast, levels = levs))

# Calculate quantiles
summary_z_win_fst <- win_fst_sel_vs_ctrl_prep %>% 
	group_by(contrast) %>% 
	summarise(n_win = n(),
	min = min(z_win_fst_score), median = median(z_win_fst_score), mean = mean(z_win_fst_score),
	q10 = quantile(z_win_fst_score, 0.10), q95 = quantile(z_win_fst_score, 0.95),
	max = max(z_win_fst_score))


q_zfst <- summary_z_win_fst %>% 
	dplyr::select(contrast, paste0("q",c(10,95))) %>% 
	reshape2::melt(id.vars = c("contrast"), measure.vars = c("q10","q95"), 
	variable.name = "Quantile", value.name = "zFst")

# Function to find regions of extreme genetic differentiation, specific for each line
find_distinct_REDs <- function(contr, rest, q_low, q_high){
  # for each contrast in rest, find bottom 
  rest_bottom_windows <- lapply(rest, function(x){
    # set threshold for bottom scores
    q_low_threshold <- summary_z_win_fst[summary_z_win_fst$contrast == x, q_low] %>% 
      as.numeric()
    # get rest-contrast individual data
    win_fst_sel_vs_ctrl_prep %>% filter(contrast %in% x) %>% 
      # get bottom scores using zFst scores
      filter(z_win_fst_score < q_low_threshold) %>% 
      ungroup() %>% 
      # select columns for joining
      dplyr::select(CHROM, BIN_START, BIN_END)
  }) %>% 
  # inner join all contrasts in rest
  purrr::reduce(inner_join, by = c("CHROM","BIN_START","BIN_END"))
  # set upper score
  q_high_threshold <- summary_z_win_fst[summary_z_win_fst$contrast == contr, q_high] %>% 
    as.numeric()
  # get top windows in contrast of interest
  contr_extreme_windows <- win_fst_sel_vs_ctrl_prep %>% 
    filter(
      # get contrast of interest data
      contrast == contr &
        # keep top zFst scores
        z_win_fst_score > q_high_threshold
    ) %>% 
    # select columns for merging
    ungroup() %>% 
    dplyr::select(CHROM, BIN_START, BIN_END)
  
    # get distinct windows
  distinct_windows <- inner_join(contr_extreme_windows, 
                                 rest_bottom_windows, 
                                 by = c("CHROM","BIN_START","BIN_END")) %>% 
    # add fst and number of variants information
    inner_join(
      win_fst_sel_vs_ctrl_prep %>% 
        filter(contrast == contr) %>% 
        dplyr::select(contrast, CHROM, BIN_START, BIN_END, N_VARIANTS, MEAN_FST),
      by = c("CHROM","BIN_START","BIN_END")
    ) %>% 
    mutate(CHROM = factor(CHROM, levels = c(1:19,"X"))) %>% 
    arrange(CHROM)
    return(distinct_windows)
}


# Find regions of distinct genetic differentiation and overlapping genes
rest_for_duk  <- paste0( c("DUC","DU6","DU6P","DUhLB"), "_vs_FZTDU" )
rest_for_duc  <- paste0( c("DUK","DU6","DU6P","DUhLB"), "_vs_FZTDU" )
rest_for_du6 <- paste0( c("DUC","DUK","DU6P","DUhLB"), "_vs_FZTDU" )
rest_for_du6p  <- paste0( c("DUC","DU6","DUK","DUhLB"), "_vs_FZTDU" )
rest_for_duhlb  <- paste0( c("DUC","DU6","DU6P","DUK"), "_vs_FZTDU" )
rest_for_fert  <- paste0( c("DU6","DU6P","DUhLB"), "_vs_FZTDU" )


distinct_windows_list <- list(
  DUK = find_distinct_REDs("DUK_vs_FZTDU", rest_for_duk, "q10","q95"),
  DUC = find_distinct_REDs("DUC_vs_FZTDU", rest_for_duc, "q10","q95"),
  DU6 = find_distinct_REDs("DU6_vs_FZTDU", rest_for_du6, "q10","q95"),
  DU6P = find_distinct_REDs("DU6P_vs_FZTDU",rest_for_du6p,"q10","q95"),
  DUhLB = find_distinct_REDs("DUhLB_vs_FZTDU", rest_for_duhlb, "q10","q95"),
  FERT = find_distinct_REDs("FERT_vs_FZTDU", rest_for_fert,  "q10","q95"))
                          
# Gene mapping 
library(GenomicRanges)
RDD_genes <- lapply(distinct_windows_list, function(x){
  wins <- GRanges(seqnames = x$CHROM, IRanges(start = x$BIN_START, end = x$BIN_END))
  gns_grs <- subsetByOverlaps(mmu_gene_set_gr, wins, minoverlap = 1) %>% unique()})
















