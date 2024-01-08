$PROB Depot Two-Cmt

$NMXML
path = "/home/cdavis14/Documents/random/nonmem_for_shiny_app/NONMEM/saem/saem.xml"
root = "cppfile"

olabels = c("ETA_CL", "ETA_VC", "ETA_Q", "ETA_VP", "ETA_KA")
slabels = c("SIGMA_EXP")

$PK
double CLi = exp(THETA1 + ETA_CL);
double VCi = exp(THETA2 + ETA_VC);
double Qi = exp(THETA3 + ETA_Q);
double VPi = exp(THETA4 + ETA_VP);
double KAi = exp(THETA5 + ETA_KA);

$CMT @annotated
GUT     : Extravascular (mass)
CENT    : Central (mass)
PERIPH  : Peripheral (mass)

$ODE
dxdt_GUT    = -KAi*GUT;
dxdt_CENT   = KAi*GUT - (CLi/VCi + Qi/VCi)*CENT + Qi/VPi*PERIPH;
dxdt_PERIPH = Qi/VCi*CENT - Qi/VPi*PERIPH;

$TABLE
double IPRED = CENT/VCi;
double DV = IPRED * exp(SIGMA_EXP);

$CAPTURE @annotated
  IPRED : Plasma Concentration (mass/volume)