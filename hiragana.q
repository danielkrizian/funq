\c 40 100
\l funq.q
\l etl9b.q

/ use a neural network to learn 71 hiragana characters
/ inspired by the presentation given by mark lefevre
/ http://www.slideshare.net/MarkLefevreCQF/machine-learning-in-qkdb-teaching-kdb-to-read-japanese-67119780

/ dataset specification
/ http://etlcdb.db.aist.go.jp/?page_id=1711


-1"referencing etl9b data from global namespace";
`X`y`h set' etl9b`X`y`h
-1"shrinking training set";
X:500#'X;y:500#y;h:500#h;

-1"setting the prng seed";
system "S ",string "i"$.z.T

-1"view 4 random drawings of the same character";
plt:value .util.plot[32;16;.util.c10;avg] .util.hmap flip 64 cut
-1 (,'/) plt each X@\:/: rand[count h]+count[distinct y]*til 4;

-1"generate neural network topology with one hidden layer";
n:0N!{(x;(x+y) div 2;y)}[count X;count h]
Y:.ml.diag[last[n]#1f]@\:"i"$y

rf:.ml.l2[1]                     / l2 regularization function
-1"run mini-batch stochastic gradient descent",$[count rf;" with l2 regularization";""];
hgolf:`h`g`o`l!`.ml.sigmoid`.ml.dsigmoid`.ml.softmax`.ml.celoss
-1"initialize theta with random weights";
theta:2 raze/ .ml.glorotu'[1+-1_n;1_n];

cf:first .ml.nncostgrad[rf;n;hgolf;Y;X]::
gf:last .ml.nncostgrad[rf;n;hgolf]::
theta:first .ml.iter[1;.01;cf;.ml.sgd[.4;gf;0N?;50;Y;X]] theta

/ncgf:.ml.nncostgrad[rf;n;hgolf;Y;X]
/first .fmincg.fmincg[10;cgf;theta]

-1"checking accuracy of parameters";
avg y=p:.ml.pova .ml.nnpredict[hgolf;X] .ml.nncut[n] theta

w:where not y=p
-1"view a few confused characters";
-1 (,'/) plt each X@\:/: value ([]p;y) rw:rand w;
-1 (,'/) plt each X@\:/: value ([]p;y) rw:rand w;

-1"view the confusion matrix";
show .util.totals[`TOTAL] .util.cm[y;"j"$p]
