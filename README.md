<p align="center">
  <img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/History.png" title="History" alt="History" width="660" height="110"/>
</p>

---

# Reading *Web of Power* ([Bai et al., 2022](https://doi.org/10.1093/qje/qjac041))

The paper by [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) has been discussed a lot (particularly by Chinese researchers) since its publication on *The Quarterly Journal of Economics*, perhaps because of its novel idea or special data. Here, I'm going to summarize this paper, replicate some of its results (by **Stata 18**), and write some comments, just for fun.

To run my codes, please install the following Stata packages in advance:
```stata
ssc install listtex, replace
ssc install outreg2, replace
ssc install estout, replace
ssc install reghdfe, replace
ssc install ftools, replace
ssc install parmest, replace
net install grc1leg.pkg, replace
ssc install ivreghdfe, replace
ssc install ranktest, replace
```
For people interested in history of Qing Dynasty and modern China (in the 20th century), I strongly recommend a book: [*The Rise of Modern China*](https://en.wikipedia.org/wiki/The_Rise_of_Modern_China) by Immanuel Chung-Yueh Hsü (written in English and first published in 1970).


## Research Idea and Difficulty
[Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041)'s main argument is that **individuals can affect macro-level outcomes via their personal networks**, especially the connections among [elites](https://en.wikipedia.org/wiki/Elite). It is hard to empirically prove this idea due to the difficulty of measuring personal networks and estimating their specific effects. [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) overcome this difficulty by exploring a specific context in Chinese history: [Taiping Rebellion](https://en.wikipedia.org/wiki/Taiping_Rebellion) from 1850 to 1864, during which the famous stateman [Zeng Guofan (曾国藩)](https://en.wikipedia.org/wiki/Zeng_Guofan) used his personal networks to organize an army in his hometown and finally helped the Qing Dynasty win the war. As Bai et al. (2022) explain, this context is useful because
  * It features a well-defined elite network based on the [imperial examination system (科举)](https://en.wikipedia.org/wiki/Imperial_examination). It's well known (at least in China) that examiners and examinees in a triennial provincial-level (乡试) and national-level exams (会试) tended to build up a master-disciple relationship, and those successful examinees attending the same exam built up a quasi-classmate relationship. These relationships (called "**baseline networks**" by the authors) could assist (or sometimes kill) each other in the future careers.
  * In this context the authors are able to measure the mobilization outcome of the elites. They have the digitalized data on soldier deaths in 1850-1864 for all counties in [Hunan](https://en.wikipedia.org/wiki/Hunan) province (Zeng Guofan's hometown). The data are collected from the Hunan Gazetteers.
  * In this context the authors are able to measure elite power; they have a database (from *The Chronicle of Officials in the Qing Dynasty*) of information on the Chinese bureaucrats in provincial- and central-government-level offices in 1820-1910. They focus on officials at these two levels because only these officials played key roles in national decision making.


## Data
The baseline measure of a county's connections in the elite networks are constructed as
$$EliteConnections_c=\sum_{n=1}^{N_c} \frac{1}{d_{c,n}}$$
where $N_c$ is the number of elites from county $c$ and $d$ is the degree of separation from Zeng Guofan. The alternative measures include counting the number of connected elites from a country (i.e., an unweighted measure) and per capita measures (i.e., dividing weighted/unweighted measures by county's population). The authors also constructed 12 country-level variables; see Section III.A.3 of the paper for details.

The summary statistics of country-level connectedness measures and 12 country-level variables are replicated and presented in the table below. Click [here](./Table_1_Summary_Statistics.do) to see Stata codes. I tried to use `dtable` (a command introduced in Stata 18) or `outreg2` (an add-in command) but neither result was satisfying. Finally, I used `listtex` package, but the coding of using `outreg2` are also shared in my do file in case that you are interested.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table1.png" title="Table 1: Summary Statistics" alt="Table 1: Summary Statistics" width="531" height="395.3"/>


## Effect on Soldier Death
The number of soldier deaths in connected-to-Zeng counties increased highly after Zeng Guofan came to power, as presented in the following figure (see [here](./Figure_4_Soldier_Deaths.do) for coding). This is motivational evidence for this research.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure4_Soldier_Death.svg" title="Figure 4: Motivational Evidence on Elite Networks and Soldier Deaths" alt="Figure 4: Motivational Evidence on Elite Networks and Soldier Deaths" width="420" height="315"/>


### Empirical Strategy and Main Results
[Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) employs a **static difference-in-differences (DID) strategy** to estimate the impact of elite connections on the number of soldier deaths. The main specification has a form
$$\ln(SoldierDeath_{c,t}+1) = \beta EliteConnections_c \times Post1853_t + \alpha_c + \lambda_t + \theta X_c \times Post1853_t + \epsilon_{c,t}$$
where $\alpha_c$ denotes county fixed effects, $\lambda_t$ denotes year fixed effects, and $X_c$ is a vector of 12 country-level control variables. All standard errors are clustered at country level. Different from a textbook DID, this specification focuses on a continuous treatment ($EliteConnections_c \times Post1853_t$) instead of a binary treatment. A theoretical econometric paper related to DID with continuous treatment is [Callaway et al. (2021)](https://arxiv.org/abs/2107.02637).

This specification uses a balanced panel data with 75 Hunan counties in 1850-1864, and it exploits two differences:
  * **Group difference**: whether or not county $c$ has elite connections to Zeng.
  * **Time difference**: whether or not the year $t$ is in post-1853 period.

Note that in this context, there is **only one treatment time**: 1853, the year Zeng took power to organize an army in Hunan. Therefore, the static DID strategy is valid under parallel trend, no anticipation, homogeneous and time-invariant treatment effect assumptions (see [Sun & Abraham, 2021](https://doi.org/10.1016/j.jeconom.2020.09.006) for theorems).

The main results are reported in the following table. The estimated impacts of elite connections are significantly positive in all specifications.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table2.png" title="Table 2: The Effect of Elite Connections on Soldier Deaths (DID Estimates)" alt="Table 2: The Effect of Elite Connections on Soldier Deaths (DID Estimates)" width="698.3" height="310"/>

Click [here](./Table_2_DID_Estimates.do) to see Stata coding, where I run the DID specifications by the `reghdfe` command (`xtreg`, `areg`, and ` xtdidregress` can also work and return the same coefficient estimates; standard error estimates and R-squared are slightly different because of different degree-of-freedom adjustments). To successfully print out my table in LaTeX, you need to load the `adjustbox` package ([documentation](https://ctan.org/pkg/adjustbox)) in your preamble. You may find the table exported by `estout` doesn't look exactly like the printed one above, because I manually adjusted it for better presentation.

To check whether identification assumptions (especially parallel trends) hold, the authors run an **event-study** (also called **dynamic**) **DID regression**:
$$\ln(SoldierDeath_{c,t}+1) = \sum_{k\in \\{1850, …, 1864\\}/\\{1853\\}} \beta^k EliteConnections_c \times 1\\{t=k\\} + \alpha_c + \lambda_t + \delta_{pt} + \theta X_c \times Post1853_t + \epsilon_{c,t}$$
where $\delta_{pt}$ denotes prefecture-year fixed effects. Year 1853 is used as a base year. The results are shown in the following figure. We can see that pre-treatment coefficient estimates are not different from zero at 95% confidence level, regardless of the ways to measure county's elite connections. This gives us assurance that the Hunan counties didn't underwent different trends before Zeng came to power.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure5_Dynamic_Estimates.svg" title="Figure 5: The Effect of Elite Connections on Soldier Deaths (Year-by-Year Estimates)" alt="Table 2: The Effect of Elite Connections on Soldier Deaths (Year-by-Year Estimates)" width="600" height="429"/>


### Robustness Check
Of course, elite connections were not only constructed on the exam relationships. In the robustness check, [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) expand their definition for elite networks by including marriage, friends, and clan relationships. Note that the authors define the clan relationship by county and surname: If people were from the same county and they share the same surname, then they belong to the same clan. This is a coarse definition, but maybe the "optimal" definition due to the limitation of data. In addition, the authors examine the results when focusing on specific types of exam connections.

The results (reported in the two following tables) show that the impacts of elite connections are always significantly positive regardless of the measure of elite networks. See [here](./Table_3_Type_of_Links.do) for coding. Notice:
  * In Columns (1)-(4), the `reghdfe` command drops 15 singleton observations so that the number of observations becomes 1,110 (instead of 1,125 reported in the paper).
  * In Columns (5)-(7), the standard errors are multi-way clustered at county and surname levels (instead of at only country level as mis-described in the paper).

<div id="Table3">
  <img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table3_1.png" title="Table 3: The Effect of Elite Connections on Soldier Deaths (Types of Links)" alt="Table 3: The Effect of Elite Connections on Soldier Deaths (Types of Links)" width="476.7" height="399"/>&nbsp;
  <img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table3_2.png" title="Table 3: The Effect of Elite Connections on Soldier Deaths (Types of Links)" alt="Table 3: The Effect of Elite Connections on Soldier Deaths (Types of Links)" width="463.7" height="341.4"/>
</div>


### Placebo Tests
Two placebo tests are done:
  * Assume that Zeng would pass the national-level exam in 1836 or 1840 (rather than 1838 in fact). Then the authors use these two placebo timings of exams (and thus placebo elite connections) to check the relevance of true elite connections. The authors even use an **instrumental variable (IV)** method:
    1. Stage 1: Run a regression of true national-level exam network on the baseline connections; then, predict the baseline connections.
    2. Stage 2: Run a regression of predicted baseline connections on the soldier deaths.
  * Use Huai region (i.e., [Anhui](https://en.wikipedia.org/wiki/Anhui) and [Jiangsu](https://en.wikipedia.org/wiki/Jiangsu) provinces) as a placebo for Hunan province. This placebo test is valid because Zeng Guofan only mobilized soldiers in Hunan by his personal networks.

The results are presented in the following tables. [Here](./Table_4_Placebo_Tests.do) is my coding. I use the `ivreghdfe` command (extended from `ivreg2` and `reghdfe`) to run the IV regressions. To use this command, four packages must be installed: `ftools`, `reghdfe`, `ivreg2`, and `ranktest`.

<div id="Table4">
  <img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table4_1.png" title="Table 4: The Effect of Elite Connections on Soldier Deaths (Placebo Networks)" alt="Table 4: The Effect of Elite Connections on Soldier Deaths (Placebo Networks)" width="467.4" height="351.4"/>&nbsp;
  <img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table4_2.png" title="Table 4: The Effect of Elite Connections on Soldier Deaths (Placebo Networks)" alt="Table 4: The Effect of Elite Connections on Soldier Deaths (Placebo Networks)" width="431.1" height="350.3"/>
</div>


## Effect on Postwar Power
[Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) also want to check whether elite connections with war contributions further shaped the distribution of postwar elite power. However, a challenge is that we hardly know how the elite connections without war contribution would affect elite power distribution. One proposed solution is using non-Hunan counties as a comparison group, given that those non-Hunan counties had elite connections in Zeng Guofan's personal networks but did not have soldier deaths in Hunan army.

The motivational evidence is presented in the figure below ([coding](./Figure_6_Number_of_Offices.do)), where the power distribution is proxied by the average number of national-level offices held by different groups (Hunan versus non-Hunan, connected versus unconnected). The two dashed blue lines denote the starting and ending years of Taiping Rebellion. Obviously, the average number of national-level offices held by officers from Hunan-connected counties increased largely during and after the war.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure6_Number_of_Offices.svg" title="Figure 6: Motivational Evidence for the Power Effect" alt="Figure 6: Motivational Evidence for the Power Effect" width="600" height="360"/>


### Empirical Strategy and Main Results
In addition to the standard DID used in the previous section, [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) employs a **triple-difference (DDD) method**. See [Olden & Møen (2022)](https://doi.org/10.1093/ectj/utac010) for an introduction to this method. The DDD specification has the following form:
$$N(Office_{c,t}) = \rho_1 Hunan_c \times EliteConnect_c \times Post1853_t + \rho_2 Hunan_c \times Post1853_t + \rho_3 EliteConnect_c \times Post1853_t + \alpha_c + \lambda_t + \theta X_c \times Post1853_t + \epsilon_{c,t}$$
where
  * The dependent variable is the number of national-level offices in county $c$ in year $t$.
  * $\rho_1$ is the coefficient of interest, measuring the power effect of elite connections.
  * $\rho_2$ measures the (dis)advantage of originating from Hunan.
  * $\rho_3$ measures the (dis)advantage of general elite connections after the war.

The main results are presented in the following table ([coding](./Table_5_DID_and_DDD_Estimates.do)). All standard errors are clustered at the prefecture level. Both DID and DDD show us a significant positive effect.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table5.png" title="Table 5: The Effect of Elite Connections on Elite Power (DID and DDD Estimates)" alt="Table 5: The Effect of Elite Connections on Elite Power (DID and DDD Estimates)" width="593.7" height="343.1"/>

The authors also run a dynamic DID regression and a dynamic DDD regression to see the dynamic effects on the number of national-level offices. The regressions are
$$N(Office_{c,t}) = \sum_{k=1821}^{1910} \beta_1^k Hunan_c \times EliteConnect_c \times 1\\{t=k\\}  + \sum_{k=1821}^{1910} \beta_2^k (1-Hunan_c) \times EliteConnect_c \times 1\\{t=k\\} + \sum_{k=1821}^{1910} \rho^k Hunan_c \times 1\\{t=k\\} + \alpha_c + \lambda_t + \sum_{\tau} \theta_{\tau} X_c \times 1\\{t \in \tau\\} + \epsilon_{c,t}$$
and
$$N(Office_{c,t}) = \sum_{k=1821}^{1910} \rho_1^k Hunan_c \times EliteConnect_c \times 1\\{t=k\\}  + \sum_{k=1821}^{1910} \rho_2^k Hunan_c \times 1\\{t=k\\} + \sum_{k=1821}^{1910} \rho_3^k EliteConnect_c \times 1\\{t=k\\} + \alpha_c + \lambda_t + \sum_{\tau} \theta_{\tau} X_c \times 1\\{t \in \tau\\} + \epsilon_{c,t}$$
where $\tau$ denotes a set consisting of three elements: period after 1853 (Zeng came to power), period between 1850 and 1864 (Taiping Rebellion), and period after 1864 ([a feast for crows](https://en.wikipedia.org/wiki/A_Feast_for_Crows) after the war). The regression results are presented below ([coding](./Figure_7_Dynamic_Impacts.do)).

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure7_Dynamic_Impacts.svg" title="Figure 7: The Dynamic Impacts of Elite Network on National-Level Offices" alt="Figure 7: The Dynamic Impacts of Elite Network on National-Level Offices" width="1050" height="350"/>


### Relationship between Soldier Death and Power Distribution
Now that we've seen that there were positive effects of elite connections on both soldier deaths in Hunan army and postwar elite power, a natural question is: What is the relationship between soldier deaths and postwar power distribution? Did higher soldier deaths from a county lead to the larger number of national-level offices held by people from the same county? [Chaos is really a ladder?!](https://www.youtube.com/watch?v=8Rc6CHH-E-4)

To find this relationship, [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) uses an IV method: The soldier deaths in Hunan army are instrumented by one/two component(s) of elite connections (the authors divide the elite connections into two components: national-level exam connections, and the rest). If a component really affected the number of national-level offices through other channels in addition to the channel of soldier deaths, we should see a significant coefficient estimate in front of this component in the structural equation.

The results are reported in the following table, where Column (1) is the same as Column (6) in Table 5. Clearly, power effects can be explained by soldier deaths. In other words, chaos (or war) is a ladder.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Tables/Table6.png" title="Table 6: The Power Effect (The Role of Soldier Deaths)" alt="Table 6: The Power Effect (The Role of Soldier Deaths)" width="634" height="608"/>

My coding is [here](./Table_6_Chaos_Is_a_Ladder.do). As before, the `ivreghdfe` command is employed to run the IV regressions. This multi-functional command always returns a long list showing bunches of estimates and statistics. We can type `ereturn list` to see all results. The table above reports the first-stage Cragg-Donald Wald *F* statistic and the *p*-value in overidentification test, which are stored in the scalars `e(cdf)` and `e(jp)` respectively.


### Additional Results
To see the implementation of elite connections on power distribution at the national level, [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) use the shares of [Jinshi](https://en.wikipedia.org/wiki/Jinshi) (进士, the highest and final degree in the imperial examination) across provinces as benchmarks, and then use the deviation of true shares from the benchmarks as a proxy for power localization. This methodology comes from Ellison-Glaeser index in [Ellison & Glaeser (1997)](https://doi.org/10.1086/262098). The results are shown in the following figure ([coding](./Figure_8_Power_Distribution.do)), where the vertical dashed line indicates the year 1853. We can see that the difference between the true EG index and the counterfactual one increased a lot after the war.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure8_Power_Distribution.svg" title="Figure 8: National-Level Power Distribution and the Contribution of Elite Networks" alt="Figure 8: National-Level Power Distribution and the Contribution of Elite Networks" width="800" height="400"/>

Next, the authors focus on the origins of the top four provincial officials, i.e., one governor (巡抚) and three vice-governors. Note that Qing Dynasty required that officials born in a province never govern the province. Assuming a simple randomization (probability of individuals from a county holding top official positions is proportional to the county's population), the authors compare the shares of top officials from Hunan connected-to-Zeng counties across three periods: pre-war, in-war, and post-war. They find that during the war, shares of top officials from Hunan rose largely, especially in those provinces most affected by the war (e.g., Guangxi, Zhejiang, and Hubei). See the following figure (comparing 17 non-Hunan provinces between periods) for an illustration.

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure9_1_Share_of_Top_Officials.svg" title="Figure 9: The Share of Provincial Officials from Connected Counties in Hunan" alt="Figure 9: The Share of Provincial Officials from Connected Counties in Hunan" width="840" height="350"/>

Finally, the authors briefly investigate the "political legacy" of the elite connections. This research direction comes from some historians; for example, [Michael (1949)](https://doi.org/10.2307/3635664) state that the rise of regional elites "marked the beginning of the disintegration of dynastic power that finally led to the collapse of the dynasty and to the system of warlordism that replaced [it]." To verify this argument, [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) focus on a famous event: [Mutual Defense Pact of the Southeastern Provinces (东南互保)](https://en.wikipedia.org/wiki/Mutual_Defense_Pact_of_the_Southeastern_Provinces). In the summer of 1900, [Empress Dowager Cixi](https://en.wikipedia.org/wiki/Empress_Dowager_Cixi), who had full administrative power over Qing, issued (on behalf of Guangxu Emperor) the imperial decree of declaration of war against 11 foreign nations.[^1] To central state's surprise, five provincial governors formally rejected to carry out the imperial decree; instead, they took a neutral position for preserving peace in their own provinces. [Bai et al. (2022)](https://doi.org/10.1093/qje/qjac041) use data to show that the share of top officials from Hunan-connected counties during the war is positively related to the probability of the corresponding province's disobeying the imperial decree. Their figure has been replicated below ([coding](./Figure_9_Top_Officials.do)). This could be (weak) evidence that regional elites became more autonomous after Taiping Rebellion. From my perspective, this finding is not surprising; after all, among the five governors, one was student of Zeng Guofan [[Li Hongzhang (李鸿章)](https://en.wikipedia.org/wiki/Li_Hongzhang)] and one had ever joined Hunan army [[Liu Kunyi (刘坤一)]( https://en.wikipedia.org/wiki/Liu_Kunyi)].

[^1]: In 2019, my Mexican friend Sofia asked me a question after her Asian History lecture: "Was Empress Dowager Cixi the most powerful woman in Chinese history?" I replied: "I don't think so. [Lady Wu](https://en.wikipedia.org/wiki/Wu_Zetian) might be more powerful. But Cixi must be bravest woman in Chinese history, or maybe in world history."

<img src="https://github.com/IanHo2019/Elite_Connection_BJY22/blob/main/Figures/Figure9_2_Prob_Disobey.svg" title="Figure 9: The Share of Provincial Officials from Connected Counties in Hunan" alt="Figure 9: The Share of Provincial Officials from Connected Counties in Hunan" width="343" height="343"/>


## Summary of Research Findings
Individuals, in special eras, nonnegligibly influence macro-level (political) outcomes.
  * One more directly connected-to-Zeng elite in a Hunan county increases the number of soldier deaths by about 21%.
  * One direct elite connection in Hunan counties is associated with about 50% more national-level offices after Zeng came to power, compared with non-Hunan counties.
  * War contribution plays a key role in the effect of elite connections on power distribution.

Click [here](./Replicating_BJY2022.pdf) to see all results presented in tables.

My personal feeling: From Qin to Qing, Chinese history sees countless rebellions started by commoners; most of them failed, after sending tens of thousands of commoners to deaths. I never think those rebellion leaders must be righteous just because they fought against the cruel or incapable rulers; however, we may never ignore their (long-term) impacts on the country's development. This paper shows me a new way to consider Taiping Rebellion. The leader of Taiping Rebellion, [Hong Xiuquan (洪秀全)](https://en.wikipedia.org/wiki/Hong_Xiuquan), who titled himself as Heavenly King and claimed himself as the elder brother of Jesus Christ, didn't bring the love of God to China in the 19th century, but he indirectly reshaped the power structure of China. In many historical events in 20th-century China, we may still hear his (or his rebellion's) echoes.
