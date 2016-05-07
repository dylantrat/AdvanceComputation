const Double_t binning[75] = {0.5, 0.65, 0.82, 1.01, 1.22, 1.46, 1.72, 2.00, 2.31, 2.65, 3.00, 3.36, 3.73, 4.12, 4.54, 5.00, 5.49, 6.00, 6.54, 7.10, 7.69, 8.30, 8.95, 9.62, 10.3, 11.0, 11.8, 12.6, 13.4, 14.2, 15.1, 16.1, 17.0, 18.0, 19.0, 20.0, 21.1, 22.2, 23.4, 24.6, 25.9, 27.2, 28.7, 30.2, 31.8, 33.5, 35.4, 37.3, 39.4, 41.6, 44.0, 46.6, 49.3, 52.3, 55.6, 59.1, 63.0, 67.3, 72.0, 77.4, 83.4, 90.2, 98.0, 107.0, 118.0, 132.0, 149.0, 170.0, 198.0, 237.0, 290.0, 370.0, 500.0, 700.0, 1000.0};


void parte1(void)
{

	//Data
	TFile * f = new TFile("data_tree.root","READ");
	TTree * t = (TTree*) f->Get("Data");


	//Ejercicio 1_1)
	ejercicio_1_1(t);

	//Ejercicio 1_2)
	ejercicio_1_2(t);

	//Ejercicio 1_3)
	ejercicio_1_3(t);

}

void ejercicio_1_1(TTree* t)
{

	//Histogramas

	TH1F * base = new TH1F("base","base",74,binning);
	TH1F * cut1 = new TH1F("cut1","cut1",74,binning);
	TH1F * cut2 = new TH1F("cut2","cut2",74,binning);

	t -> Draw("energy>>base");
	t -> Draw("energy>>cut1","betahval>0.5");
	t -> Draw("energy>>cut2","inside_tracker==1 && trchisqx>0 && trchisqx<10 && trchisqy>0 && trchisqy<10");

	//Cortes
	TEfficiency * eff_cut1 = new TEfficiency( (const TH1) cut1, (const TH1) base);
	TEfficiency * eff_cut2 = new TEfficiency( (const TH1) cut2, (const TH1) base);

	//Eficiencias
	eff_cut1 -> Paint();
	eff_cut2 -> Paint();
	TGraphAsymmErrors * geff_cut1 = eff_cut1->GetPaintedGraph();
	TGraphAsymmErrors * geff_cut2 = eff_cut2->GetPaintedGraph();

	//Graficas
	geff_cut1->SetLineWidth(2);
	geff_cut2->SetLineWidth(2);

	geff_cut1->SetLineColor(kRed);
	geff_cut2->SetLineColor(kBlue);
	TCanvas canvas;
	TH1F * hframe = canvas.DrawFrame(0,0,1100,1);
	geff_cut1->Draw("P");
	geff_cut2->Draw("P");
	hframe->SetTitle("Cut Efficiency Comparison; Energy [GeV]; Efficiency");
	canvas.SetLogx();
	canvas.SetGridx();
	canvas.SetGridy();
    TLegend *leg = new TLegend(0.18,0.55,0.65,0.70,NULL,"brNDC");
    leg->SetLineColor(0);
    leg->SetFillColor(0);
    leg->SetFillStyle(0);
    TLegendEntry *entry=leg->AddEntry(geff_cut1,"BetaHval > 0.5","LPE");
    TLegendEntry *entry=leg->AddEntry(geff_cut2,"Tracker & 0<Tr#Chi^{2}_{x}<10 & 0<Tr#Chi^{2}_{y}<10","LPE");
	leg->Draw();

	//guardando las graficas
	canvas.SaveAs("AMS_Cuts.png");

	return;
}

void ejercicio_1_2(TTree* t)
{
	//Definiendo un histograma
	TH2F * h2 = new TH2F("h2","Energy vs [TOF charge > 0]; Charge ; Energy (GeV)",30,0,30,600,0,6000);

	//Corte las cargas positivas
	t -> Draw("energy:chargetof>>h2","chargetof>0");

	//Perfil de Histograma
	TH1D * h2charge = h2 -> ProfileX();
	h2charge -> SetTitle("Profile; Charge ; Energy (GeV)");

	//Scatter Plot
	TCanvas canvas;
	canvas.Divide(1,2,0.01,0);
	canvas.cd(1);
	h2 -> SetMarkerStyle(8);
	h2 -> SetMarkerSize(0.4);
	h2 -> SetMarkerColor(kRed+1);
	h2 -> Draw();
	gPad -> SetLogy();
	gPad -> SetGridy();
	gPad -> Modified();
	gPad -> Update();
	canvas.cd(2);
	gPad -> SetGridy();
	gStyle->SetOptStat(0);
	h2charge -> Draw("E1");

	canvas.SaveAs("AMS_Energy_ChargeTOF.png");


	return;
}

void ejercicio_1_3( TTree* t)
{
	//Definiendo la referencia en tiempo GMT (UNIX time): 00:00:00 of August 7th, 2011,
	Double_t time_zero = TTimeStamp(2011,8,7,0,0,0).AsDouble();

	//Binning for 3 days, form August 7th to 9th, 2011 -------- binning for energy
	TH2F * h2 = new TH2F("h2","h2",3,time_zero,time_zero + 3.*24.*3600.,  600,0,12000);

	//Fill the histogram
	t->Draw("energy:time>>h2");
	h2->Draw("colz");

	//Obteniendo el numero de eventos por dia
	TH1D* h_day = h2->ProjectionX();
	TH1D* h_dayly_E = h2->ProfileX();


	//Perfil
	TCanvas canvas;
	canvas.Divide(1,2,0.01,0);
	canvas.cd(1);

	h_day ->SetLineWidth(2);
	h_day -> SetLineColor(kGreen+3);
	h_day -> SetTitle("Dayly Event Count; ;Events");
	h_day -> Draw();

	gPad -> SetGridy();
	gPad -> Modified();
	gPad -> Update();

	canvas.cd(2);
	gPad -> SetGridy();
	h_dayly_E -> SetLineWidth(2);
	h_dayly_E -> SetLineColor(kRed);
	h_dayly_E -> SetTitle("Dayly energy profile; Date ; Energy (GeV)");
	h_dayly_E -> GetXaxis() -> SetTimeDisplay(1);
	h_dayly_E -> GetXaxis() -> SetTimeFormat("%d-%m-%Y");
	h_dayly_E -> Draw("E1");

	canvas.SaveAs("AMS_dayly_energy.png");

	return;
}


void parte2(void)
{
	TTree * t = new TTree("t","t");
	t->ReadFile("Jpsi.csv");

	//Histogramas para mantener medidas Jpsi mass
	TH1F * h1 = new TH1F("h1","h1",100,60,150);
	TH1F * h2 = new TH1F("h2","h2",100,66,150);
	TH1F * hJ = new TH1F("hJ","hJ",100,2,5);

	t->Draw("1000*sqrt(E1*E1-px1*px1-py1*py1-pz1*pz1)>>h1");
	t->Draw("1000*sqrt(E2*E2-px2*px2-py2*py2-pz2*pz2)>>h2");
	t->Draw("sqrt((E1+E2)*(E1+E2)-(px1+px2)*(px1+px2)-(py1+py2)*(py1+py2)-(pz1+pz2)*(pz1+pz2))>>hJ");

	//Perfil
	gStyle->SetOptStat(0);
	TCanvas canvas;
	canvas.Divide(2,1,0.01,0.01);
	canvas.cd(1);

	h1->SetLineWidth(2);
	h2->SetLineWidth(2);
	h1->SetLineColor(kRed-3);
	h2->SetLineColor(kRed+3);

	h1 -> SetTitle("Muon 1 reconstructed mass; Mass (MeV/c^{2}; Events");
	h2 -> SetTitle("Muon 2 reconstructed mass; Mass (MeV/c^{2}; Events");
	h2 -> Draw();
	h1->Draw("same");

	gPad -> SetLogy();
	gPad -> Modified();
	gPad -> Update();

        TLegend *leg = new TLegend(0.18,0.55,0.65,0.70,NULL,"brNDC");
        leg->SetLineColor(0);
        leg->SetFillColor(0);
        leg->SetFillStyle(0);
        TLegendEntry *entry=leg->AddEntry(h1,"Muon 1","LPE");
        TLegendEntry *entry=leg->AddEntry(h2,"Muon 2","LPE");
		leg->Draw();

	canvas.cd(2);
	hJ -> SetLineWidth(2);
	hJ->SetLineColor(kBlue+1);
	hJ -> SetTitle("Dimuon invariant mass ; W (GeV/c^{2} ) ; Events");
	hJ -> Draw("E1");
	canvas.SaveAs("Dimuon_invariant_mass.C");

	return;
}
