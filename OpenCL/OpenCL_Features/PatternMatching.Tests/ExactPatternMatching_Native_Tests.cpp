#include <windows.h>
#include "CppUnitTest.h"
#include <vector>
#include <string>
#include <algorithm>
#include <sstream>
#include <fstream>
#include <streambuf>
#include "Utilities.h"

#include "PatternMatching.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;
using std::vector;
using std::string;


namespace ExactPatternMatchingTests
{
	using PatternMatching::Native::findExactPattern;

	//Pattern Matching Problem : Find all occurrences of a pattern in a string.
	//	Input : Two strings, Pattern and Genome.
	//	Output : All starting positions where Pattern appears as a substring of Genome.

	TEST_CLASS(ExactPatternMatching_Native)
	{

	public:

		TEST_METHOD(OCL_FindExactPattern_TinyStartMiddleEnd)
		{
			vector<size_t> actual = findExactPattern("ATT", "ATTCTATTGATT");
			Assert::AreEqual(std::string("0 5 9"), concatenate(actual));
		}

		TEST_METHOD(Native_FindExactPattern_Short)
		{
			vector<size_t> actual = findExactPattern("ATAT", "GATATATGCATATACTT");
			Assert::AreEqual(std::string("1 3 9"), concatenate(actual));
		}

		TEST_METHOD(Native_FindExactPattern_Long)
		{
			string expected{ "19 24 38 49 56 80 128 164 186 225 230 239 387 403 413 419 426 471 482 508 520 604 613 618 623 646 651 679 684 691 713 727 747 770 777 784 801 829 836 841 897 947 986 991 1011 1036 1075 1148 1153 1158 1173 1186 1194 1199 1220 1232 1262 1267 1303 1329 1369 1386 1395 1407 1444 1467 1472 1477 1516 1521 1530 1555 1560 1599 1604 1625 1640 1648 1653 1666 1680 1698 1728 1733 1745 1770 1800 1805 1812 1817 1822 1856 1872 1877 1889 1933 1942 1947 1952 1972 1983 2004 2016 2021 2032 2041 2046 2073 2131 2153 2172 2218 2223 2229 2234 2272 2290 2312 2430 2440 2460 2465 2486 2497 2547 2560 2595 2645 2678 2716 2721 2745 2751 2772 2788 2793 2831 2849 2854 2860 2865 2900 2905 2911 2916 2941 2947 2960 2975 2980 2991 2996 3001 3040 3063 3081 3102 3107 3112 3124 3129 3142 3152 3157 3188 3193 3216 3224 3279 3284 3305 3310 3315 3320 3345 3357 3362 3385 3397 3402 3418 3431 3445 3517 3526 3537 3580 3585 3643 3675 3694 3712 3728 3739 3753 3772 3777 3792 3797 3824 3835 3847 3852 3857 3862 3877 3882 3888 3893 3900 3919 3930 3935 3950 4032 4053 4088" };
			vector<size_t> matches = findExactPattern("ACACCA",
				"CCGAACACCCGTACACCGAACACCACACCACACCTTGCACACCACACCTACACCACACACCACACCGGACACCCACACCCACACCACGAACACCGAGAGTACACCTACACCTGACACCGGGGATCGTCACACCAAGTGGTGATACACCCACACCCTTTACACCTACACCACACCCGTACACCCTGAACACCACACCTAGAGAGTTGCACACCTCACACCGAAGGCACACCACACCATCCACACCATAAACACCGTTAACACCGTAGAACACCCAGCACACCCTTACCGCATACACCGACGTTAGACACCCACACCGGCAGTCACACCGTACACCCATTCGGTCCACACCCTACACCGCCTGCCACACCTACTGAGTTACACCGCATGACACCATTATCCGAACACACCAATATACACCAACACCATACACCATTTAACACCCCAAAACACCGACACCGACACCGCAAGCCCACACCACACCCACACCACAGACACCTACACCGTTTAGACACCAACACCGACACCACACCCCACACCCAAGACACCGCTACACCCTGCTGGACACCGACACCTACACCTCACACCGGACACCGCACACACCGCCACACCAATCACACCACACCACACCAGTACAACACCGACACCTACACCACACCACACCCAGATACACCCACACCGGACACCACACCAAACACCATTACACCCACACCGGTACACCACACCTCGTACACCAAGTAGACACCCAACACACCACACCTTGATGACACCTGACACCATACACCAAACACCACACCGAGGTAGACACCACACCGCCATCGACCACACCCTGACACCATACACCACACCACACCTAGTCGACACCCACACCCTCACACCTGACACCCGCGGCATACACCCACACCACTTACACCTACACCGGGGGAAACACCGAAACACCTCAACACCGGACACCACACCTAAGACACCGGGCGATACACCTGACCCTGACACCACACCACACCCAACACCCGAACACCACACCCAAACCTTGACACCCACACCAAAACACCCTTTATTAAAACACCCCGACCACCAAACACCACACCCCACACCGAACACCCACACCGCATACACCGGTCACACCTTATCTCGCCCACACCCTACACCCCACACCACACCACACCACACCGTACCACACCACACCCCCACACCAAAACACCACACCACACCGGTTACACCCCACACCAACACCCACACCATTACACCTACACCGCAACACCTGCACACCACACCAAGACTGGAGACACCTACCACACCCTCGTTTACACCACCTGACACCTTACACCTCCGACACCAAAAACCCGTTGGGTCATCGGATCAGGACACCTTTACACCACACCTTCGAGGACACCACGGACACCACACCCCACACCACACCGGTACACCGCGTTCACACCTCACACCGACACCACACCCCCTGAACTGTATACACCACACCACACCAACCCAACACCCTAGAAGACACCTGCCACACCTTACACCACACCACCGACACCAACACCCAAACACCTTTGACACACCACACCAACACCGTACACCGCAACACCCGCATTACACCTTACACCACACCACACCCCCCTACACCCACACCACACCCTCGGACACCAGTACACCACACCACAGATAGACACCATACACCTTACACCACATACACCTTTCACACCACACCCACACCCCGCTTAGACACCGACACCACACCACACCTGACACCACACCTCGCACACCGCCCTTACACCACACCCCAGCAGAAAACGAACACCCACACCACACCACACACCACACCACACCACACCGACACCTGACACCTAAACACCCCCACACCACACCTCTCCAACACCACACCAACACCTACACCAGAAAGACACCGACACCCGACACCCGCTGTTGTACACCCACACCATCGACACCACACCACACCACACCCTACACCGGCACACCATGCAAACACCACACACCTGGACACCCACACCACACCGCACACCACACCACACCTACACCACCGACACCACACCACACACCTACTCCACAACACCTACACCAAACACCCTACACCTACACCTACACCTACATACACCTACACCTAATATTATGGACACCACACCTTCAGACACCGTACACCACACACCCTATGTTACACCACAGGCAGAATTTGACACCTCACACCCACACCCACACCCGCACACCACACCAACACCACACCACACCCCCAACACCGCTCTTACACCTTACACCGACACCAACACCGACACCGACACCACACCCCAATATCCCTCACACCACACCTAACCAGTATACACCGTTGACAACACCCCAATTTACACCCCATACACCTCAGACCACACACCGGACGGGCAACACCTACACCGATGTTACTTTACACCGGGCTCGCGGACACCACTCGACACCAACACCCGACACCTTACACCACACCAGCTGCGTGAACACCTACACCATCCCAACACCACACCGACACCGTATGGACACCTACACCTCGAGAGTTCCGCTAGAACACCACACCCATACACCATACACCGCGTACACCGAACACCGACACCCACACCACACCCAATGACACCGATGACACCGGCTCGATACACCTACACCGAACACCATCAGACACCGCGTACACCCAACACCTGACACCAACACCGCGGCACACCTAGTGACACCTACACCTACACCACACCATACACCCTACACCGATGAACACCAACACCACTCTAAACACCCAGGACACCAACACACCTAGACACCACACCAACGACAGAGACACCCTACACCTGCCAAGCTTTACACCATTGGTGAATCACACACCACACCAACACCACACCACACCGCTTACACCCGACCCGAAAACACCCACACCACACCAACACCACACCACATTACTCCCGTTACACCTACACCAACACCACACCTTTACACCACACCCAGCAACACCACACCAAATGGACACCACACCACACCACACCTTAGCCGATGTGCCGACACCGCTGTCGTCACACCAGTGACACCTTAGCGTACACACCACACCCAACACCTACACCACACCCGAAACACCTGACACCACACCACACCACACCCTACACCACACCATGACCACACACCAGCCGACACCACACCATACACCTACACCGAAACACCTTTCTACACCACACCACACCTGAACACCTAGTCACACCACGACACCAACACCTGACCACACCGGGGGACACCTTTGGAACGACACCTAACACCGCCACACCACACCACACCCGACACCTATAACACCACACCACACCACACCAAAGGCACACCTTAACACCCACACCAAGGGCTACACCACACCACACCTCCAAAACAAGGGACACCACACCCAACACCACACCACACCGCGTGGACACCACACCTTGACACCAAATTGTGCACACCACACCTGCACACCTTAAGAACGACACCGTCAGTACACCGAAACCCTATGACACCTGGGACACCTGGCACACCAACTACACCACACCCACACCACACACCTGGACACCGTTTCGCGAGTGTGGGTTGCTTGACACCACACCACACCGCGGCCTTACACCGCACACCGTAAACACCGTTGACACCTCATTACTCGACACCACACCGCACACCCACACCCGACACCGAACACCACACCTGGGCATACACACCACACCGTACACCTACACCACACCTGTGCTACACCAGGGGTACACCACACCTAGTACACCACACCGATACACCCACACCACACCACACCCACCAACACCACACCATCAAGAACACCCTATACACCCACACCACACCTACACCACACCCTACACCACACCACACCACACCATCGACACCTACACCACACCAACACCACACCAAACACCACACCCACACCCGGACACCACACCCACACCACACCATAACACCTAACACCACACACCTACACCTACTCTGCTAAACACCCAACACCTCTACACCCTGCCGACACCGCGACACCGGCGACACCCTGTTACACCACACCTCACACCTTCGACACCAGCCAGAGACACCGGACACCGACACCCCGAACACCAACACACCCGA");
			string result = concatenate(matches);
			printResults(result);
			Assert::AreEqual(expected, result);
		}

		TEST_METHOD(Native_FindExactPattern_Quiz)
		{
			string expected = "45 108 139 175 210 216 312 464 483 537 562 586 660 726 732 760 808 814 820 845 919 925 931 1029 1045 1051 1088 1191 1231 1237 1334 1340 1381 1387 1456 1482 1544 1550 1588 1684 1690 1714 1756 1921 2044 2050 2064 2070 2076 2099 2105 2111 2181 2187 2251 2282 2320 2341 2347 2357 2363 2369 2400 2406 2426 2505 2550 2556 2570 2590 2596 2602 2608 2622 2637 2675 2681 2691 2716 2762 2768 2795 2817 2825 2831 2837 2857 2863 2876 2882 2888 2903 2921 2927 3008 3014 3020 3026 3039 3127 3221 3250 3268 3330 3354 3379 3392 3440 3462 3468 3518 3601 3638 3700 3706 3712 3736 3767 3781 3820 3826 3868 3888 3903 3951 4040 4098 4164 4170 4194 4267 4313 4319 4333 4339 4388 4405 4418 4439 4478 4484 4505 4563 4576 4651 4759 4782 4788 4848 4854 4860 4866 4889 4895 4901 4949 4955 4999 5020 5057 5063 5069 5082 5126 5150 5190 5196 5225 5231 5237 5243 5304 5331 5351 5357 5372 5425 5502 5653 5659 5681 5749 5755 5785 5791 5808 5903 5909 5963 5973 6085 6115 6136 6142 6162 6187 6200 6214 6229 6242 6279 6285 6291 6313 6347 6353 6359 6365 6390 6396 6402 6455 6472 6515 6560 6613 6644 6650 6673 6679 6711 6717 6723 6739 6745 6751 6757 6835 6853 6896 6928 6934 6963 6996 7096 7114 7161 7240 7286 7292 7368 7374 7391 7425 7507 7513 7574 7649 7670 7692 7756 7762 7768 7811 7843 7928 7982 7998 8031 8037 8066 8116 8122 8173 8179 8189 8233 8273 8301 8313 8346 8377 8394 8421 8438 8462 8497 8503 8511 8570 8578 8601 8607 8663 8693 8742 8782 8795 8801 8823 8860 8905 8929 9001 9017 9023 9047 9053 9067 9137 9143 9157";
			vector<size_t> matches = findExactPattern("ATCAGCAT",
				"CCAATTTTCATCAGCCGTATCAGCTATCAGCTACTGTATCAGCTAATCAGCATCAGCTGGAGGCCGGATATCAGCTTGTAAAATCAGCCTACCTTAATCGATCAGCGAATCAGCATGTCACAATCAGCAAACTGTCTATATCAGCATCAGCTCTGTGATCAGCGAGATCAGCTGAATCAGCATCAGCGCGACACCATCAGCGCATCAGCCATCAGCATCAGCATCAGCTGGGCCCAATCAGCTGGAGAGATCAGCCATATCAGCTTCCCGTGTTATTATCAGCGCGCATCAGCTAATCAGCAAGAATCAGCTATCAGCATCAGCGGCTATCAGCGCGGCATAAATCAGCGTGATCAGCAATCAGCTTGTGTCGGCCTATCAGCGAATCAGCAGATCAGCGTTATCAGCACGATCAGCCTCCTATCAGCTTTTAAATCAGCGCATCAGCGTGTCATCAGCTTCCAATCAGCATCAGCCGTCGGAATCAGCATCAGCCATCAGCTGGGATACATCAGCTGATCAGCGTATCAGCGCTACATCAGCATCAGCGAGGGTTCCTTTCATCAGCATCAGCCACGAATCAGCTATCAGCATCAGCCCATCAGCGATAGGATCAGCACAATCAGCTGCAATCAGCCATCAGCTATCAGCGGCTGTTCGATCAGCATCAGCGACCTCATCAGCTCGATCAGCGACAATCAGCACTATCAGCGGATCAGCAGAGCCATCAGCATCAGCATCAGCCTAATCAGCTTGCTATATCAGCATCAGCCGACTGGTTGGTCCAATCAGCTATGGGACATCAGCTATCAGCATCAGCATCAGCATCAGCGACATCTCTGGCAATCAGCATCAGCGTGCGATCAGCCAATCAGCAGCCATCAGCGTGGTATCAACAGTTCGTATCAGCGAATCAGCAATCAGCATCAGCATCAGCATCAGCCCATCAGCCCCAAACGGTCCCGATCAGCTTCGCGCGCATCAGCCCTCGACATCAGCGATCAGCTAAGATGTCATCAGCCTTGTGACATCAGCATCAGCAGAGATCAGCATCAGCATCAGCCATCAGCAAAATCAGCTATCAGCGGATCAGCATCAGCGCGATGATCAGCTATCAGCCGGCATCAGCGGATCAGCCGATGCCCGGATATCAGCCCGAGATCAGCTATCAGCACGTTCTCATAATCAGCGATCAGCATCAGCGAGTCATCAGCGAGATCAGCAATCAGCTATCAGCATCAGCATCAGCTCTATCAGCGCTATCAGCCATCAGCGCGAGAATCAGCAAATCAGCAATCAGCAGATCAGCTTATCAGCTATCTAATCAGCGAGCGATCAGCATCAGCATCAGCGATCAGCCACATCAGCTACATAATCAGCAATCAGCATCAGCATCAGCCTCATTATAATCAGCAACATCAGCTGCGTGTATCAGCCAACATCAGCCTCACCCCACATCAGCATCCATCAGCGATCAGCAGCATCAGCATCAGCCAGATCAGCTGATCAGCCTAGATCAGCGATCAGCGCGAGACAGATCAGCCATCAGCATCAGCATCAGCTAATCAGCTTGTTCAAATCAGCCCTGATCAGCATCAGCCCCACAATCAGCCCTCGGACCATCAGCGAATAAATCAGCTCGCATCAGCAATCAGCCATCAGCAATCAGCGGAATCAGCACCTTATCAGCATCAGCATCAGCCGTATCAGCTACATCAGCATCAGCTGTCATCAGCGCTTTATCAGCCGTGGCTGAATCAGCATCAGCTCGATCAGCGCATCAGCTCGATATCAGCCCGCTTCATCAGCTCATCAGCACATCAGCGGGATCAGCGATCAGCCTCTGAGATCAGCGCCATCAGCTAAAATCAGCAGTGACTGACATCAGCGTATGATCAGCACATCAGCGTCTATCAGCCCGATCAGCATCAGCAAATCCTGCTGGAAGACTATCAATCTGAATCAGCGATCAGCGATCAGCCGCCAATCAGCGTATCAGCAATCAGCAATCAGCAATCAGCGCCTGGCATCAGCTATCAGCTTGATCAGCATCAGCATCAGCGAATCAGCATCAGCATCAGCATCAGCACATCAGCCGTATCAGCATCAGCATCAGCATCAGCCTATCAGCTCTAATCAGCCTTATCAGCGGAGGCTCCTGAAATCAGCCACTCATCAGCTATCAGCATCAGCATCAGCTAGAATCAGCCATCAAATCAGCTATAAATCAGCAGATCAGCCGTATCAGCCGATCAGCATCAGCGCATCAGCGATCAGCCGGAATCAGCATCAGCTTGACCATCAGCCACACAAATCAGCAATCAGCATCAGCTCATCAGCCATCAGCATCAGCATATATCAGCATCAGCATCAGCATCAGCAATCAGCTATCAGCTGGCTATCAGCATCAGCATCAGCCATCAGCCATCAGCATCAGCGCCGATCAGCCTTCAATCAGCCATCAGCTACCATATCAGCGAATATCAGCGTATGATCAGCGCTGAGATCAGCATGGTCTATTCAGATCAGCAGAATTGAATCAGCTATCTCATCAGCATCAGCATCAGCCCATCAGCATCATCAGCTAACAATCAGCATCAGCATCAGCATCAGCATCAGCGTATCAGCATCAGCGCTATCAGCATCAGCAATCAGCTCTACAGTGCATCAGCTTTATCAGCATCAGCATGCATCAGCATCAGCTGGATCAGCTCGGATCAGCATCAGCAATCAGCTCACTCAAATCAGCGCCCATCAGCGTAATCAGCATCAGCATCAGCGAAATCAGCCTTTTTATCAGCATCAGCAGATCAGCTCATCAGCATATCAGCATCAGCATCAGCATCAGCGGAGTAGAATCAGCATCAGCATCAGCGATCAGCATCAGCATCAGCATCAGCGCCATCAGCATCAGCCCCGCAATCAGCATCAGCATCAGCGCGAAATCAGCCCGCCATCAGCGGACATCAGCCTCCACCATCAGCTATCAGCACAGGGCCGATCAGCCAATCAGCATCAGCATCAGCATCAGCATCAGCAATCAGCATCAGCTAATCAGCTAATCAGCCCGTAGTATCAGCGAAAATCAGCGGAAGCATCAGCAATCAGCCACAATCAGCGATCAGCCATCAGCATCAGCCCATCAGCCGGTGATCAGCAATCAGCTATCAGCAGTGATCAGCTATCAGCGCGATCATCAGCTTAGATTCTCTTATCAGCCCATCAGCATCAGCTATATCAGCCCACTAGCATCAGCATCAGCGGCGGGATCAGCATCAGCGATCAGCCCATCCACATCAGCACATCAGCCAATCAGCCATCAGCCGAGAGATCAGCATCAGCCGTATCAGCGCGATCAGCATCAGCAGACAAATCAGCCATCAGCATCAGCCATCAGCATCAGCCATCAGCTAATCAGCAATCAGCGATCAGCGACCAAGATCAGCATCAGCCAAAGAATTTATCAGCATCAGCATCAGCGTATCAGCGCATCAGCCGGAATCAGCGTGATCAGCTAGATCAGCATCAGCGTATCAGCGAAGAATCAGCTATCAGCAATCAGCAGATGATCAGCTTAATCAGCTAGTGAAATCAGCGCAAAATCAGCATCAGCTACGTGTTCATCAGCTACATCAGCAATCAGCATCAGCCGGGATCAGCTGGGCATCAGCCAATGATCAGCTATCAGCAGCTCATAAGTATCAGCATCAGCATCAGCATCAGCGATCAGCAAGTTATCAGCATCAGCGCATCAGCAAATCAGCGACATCAGCATCAGCACATCAGCATCAGCCCCATCAGCTATCAGCTGCATCAGCTGATCAGCATCAGCATGTATCAGCCGGCATCAGCCCTATCAGCAAAACGTATCAGCATCAGCGATCAGCGATCAGCATCAGCCTTATCAGCATCAGCGCGGATCAGCCCCATCAGCAGATCAGCTATCAGCAGATCAGCATCAGCGAATCAGCCATCAGCCCTGAAATCAGCACCATCAGCCATCAGCTGTTGCGATCAGCGATCAGCTGCATCAGCTGGAGATCAGCATCAGCAGTCATCAGCCATCAGCCGCATCAGCTATCAGCTGCGAATCAGCGTATCAGCATCAGCAATCAGCTGAATCAGCTATCCTAATCAGCTTTGAATCAGCAAGTGTATCAGCACATCAGCATCAGCATCAGCTCTATCAGCCCTATCAGCATCAGCGGATCAGCAATCAGCTTTCATCAGCAATCAGCTAATCAGCACAGAACATCAGCCCCACACCATCAGCATCAGCACAATCAGCGTACAGAGAGATCATCAGCCTGGGCATCAGCATCAGCATCAGCAGATCAGCATCAGCATCAGCAGATCATATCCGAGGATCAGCGGATCAGCTATCAGCCATCAGCATCAGCGATTGATCAGCATCAGCGATCAGCATATCTCTTTGGGAAATCAGCATCAGCGCATGATCAGCAATCAGCGATCAGCCAATCAGCATCAGCATCAGCAGATCAGCAATCAGCATCAGCTCATCAGCTAAATCAGCTGTCGACAAGGAGCTTTCCCTATCAGCCTATCAGCATCAGCCATCAGCATCAGCGTACCGCATCAGCCCAATCAGCCCACCTCTCAATCAGCAGTTATCAGCAATCAGCCTCCGCACATCAGCATCAGCGATCAGCTCATCAGCGGTGGTTAATCGATCAGCCATCAGCTCATCAGCTCCCTTAGAATCAGCTCAAAAATTGATCAGCCTATCAGCCATCGCTTGATCAGCATCAGCCCATCAGCCACATCAGCATCAGCATCAGCGATCAGCTGATCAATCAGCGTAATCAGCTTTGAGCCAATCAGCCAGACATCAGCATCAGCATCAGCATCAGCATCAGCTCCCATCAGCTATCAGCATCAGCATCAGCATCAGCGATCAGCCCAAATCAGCACCATCAGCTATCAGCGGGATCAGCATCAGCATCAGCGCGGTAAATCAGCGGATCAGCTTAATCAGCCGATCAGCATCAGCAATGAAACAATCAGCATCAGCGTATCAGCTATCAGCTGTTTAACACATCAGCATCAGCATCAGCATCAGCTATCAGCATCAGCCATCAGCCTATCAGCGGATCAGCGGATCAGCAATCAGCATCAGCCGATCAGCCAGTATCAGCATCAGCAATCAGCCAATCAGCGCGAAGCATATTGATCAGCATCAGCATCAGCTCATCAGCCTATCAGCGATCAGCATCAGCATCAGCATCAGCATCAGCGATCAGCAATCAGCCTTATCAGCAAATCAGCAATCAGCTGATCAGCCAGATCAGCATCAGCGGATCAGCACGTGCGATCAGCATCCAGGATCAGCCATCAGCATCAGCATCAGCCCGATCAGCATCAGCTTGGATCAGCACGCATCTAGAATCAGCGATTTGCACAACGGATCAGCATCAGCCTTAAATCAGCCTATCAGCGGATCAGCCCCAGTAATCAGCCACATCAGCGAAGTCGTAATCAGCTATCAGCATCAGCAGAGTGCTGACATGATCAGCCCAACCATCAGCGTCTATCAGCACCCATCAGCTGCAGATCAGTAGGGGGTCATCAGCCTTTCTAATCAGCTTCGATAAGACATCAGCTAGTACATTCTATCAGCCATCAGCGGCCAGCCATCAGCATCAGCATCAGCAATCAGCTAGATCAGCATCAGCACGTGAGAATCAGCGGAGATCAGCACGAATCAGCCCCGGTGTCTGAATCAGCAAGTATCAGCATCAGCATCCAAACGATCAGCCATCAGCTTATCAGCATCAGCATCAGCTTTTTATCAGCATCAGCCCCATATCAGCTATCAGCGGATCAGCAGCATATCAGCCATCAGCGATCAGCCGATCAGCGTGATATCAGCCAGAGATCAGCGTATCAGCATCAGCATCAGCCGATCAGCTGGACATACGAAATCAGCAGTGATCAGCTCGTGAATCAGCATTTATCAGCATCAGCGTCAATCAGCCTGATCAGCCCGTCATCAGCCTTTAATGCGATTTTCAATCAGCTGACAAGAGGCCATCAGCCCAGAATCAGCAGTATCAGCGATCAGCGTATCAGCATACAACTGACTGCATGGTCATCAATCAGCATCAGCGCGCACCGTATCAGCATCAGCATCAGCTATCAGCAATCAGCATCAGCACATCAGCGGTTTATCAGCATCAGCAATCAGCATCAGCCTATCAGCATCAGCGCAATCAGCATCAGCCATCAGCATCAGCACTATCAGCTGGAAAAACGTCTGTCATCAGCATCAGCATCAGCATCAGCACAATCAGCCATCAGCATCAGCGCATCAGCTATTCGATCAGCCAATCAGCATCAGCATCAGCATCAGCATCAGCGAATCAGCAGCGTATCAGCATCAGCATCAGCATCAGCAGATCAGCGCACCAATCAGCTTATCAGCCTATCAGCCATACATCAGCATCAGCCCGAGATCAGCATCAGCGTGGATCAGCCCAGATCAGCGATCAGCTTGAATCAGCATAAGCAATCAGCAGTATCAGCGTGGAACATCAGCACTGATCAGCATCAGCCTGGGGAAATCAGCCCTACGTGTTATCAGCTATATCAGCTTATCAGCATCAGCTAAATCAGCTATCAGCAACATCAGCATCAGCATCAGCCATCAGCTGAAATCAGCATCAGCATCAGCTGATCAGCTGATCAGCCATGATCAGCATCAGCATCAGCATCAGCAGACATCAGCATCAGCATCAGCATCAGCATCAGCACAAATCAGCAAGCGCGAGCTGTCAATCAGCGCATCAGCGGTCACTACATCAGCGGTATCGTAGATATCAGCATTTATCAGCCTATCAGCATATCAGCTATCAGCCTGATCAGCCGCACATCAGCTGATCAGCATCAGCCCCTGGCGATCAGCAAGTTAATCAGCATCAGCATCAGCAACAGATCAGCTGTTCAATCAGCATAGATCGGATTTATCAGCTATCAGCCATCAGCATCAGCAAACCTATCAGCCATCAGCAGAGATCAGCAAATCAGCAATCAGCCATCAGCAATCAGCTTTCGATCAGCGGGCCAATCAGCAAGCAATATCAGCATAATCAGCCCTATCAGCATCAGCGTGTGATCAGCAATCAGCTACATCAGCCATCAGCGATCAGCATATAATCAGCAGATAACATCAGCTGCAATCAGCAAGATGCGGGATCAGCCCTATCAGCTCTAAATCAGCCCAATCAGCATCAGCAATCAGCCATATTGCAATCAGCTCCATCAGCGGGATCAGCATCAGCATCAGCTGAGGCGCGGCCAATCAGCGATCAGCTAATCAGCGGGATCAGCAGCAATCAGCTATCTCATACGATCAGCATCAGCATCAGCCCGGCATCAGCATCAGCTATCAGCCCGATCAGCTCACTGATCAGCATCAGCACATCAGCTCATCAGCGATCAGCAATCAGCTGATCAGCAGGCGTCTTATTCATATCAGCTTTGATCAGCAATCAGCATCAGCATCAGCCGATCAGCTCCAAGATCAGCTGCTTACTTTATCAGCGCGGCATCAGCGCATCAGCATCAGCGACTGAATCAGCCGAGCACATCAGCGCATAGATCAGCTAATCAGCCACATCAGCACCGGTTCTATCAGCATCGATTGAAGTCCCATCAGCATCAGCGATCAGCGTCATCAGCATCAGCTATCAGCTTCGGATCAGCAGGTAAGTATCAGCTTGCATCAGCCTCATCAGCAATCAGCATCAGCATCAGCATCAGCAGGATCAGCGCATCAGCAAAGAATCAGCTTTATCAGCATCAGCAATCAGCTCTGGGATCAGCGATCAGCATCAGCTCTGCCAATCAGCTAACTGATCAGCGATCAGCGATCAGCCATCAGCCATCAGCGTGATATCAGCCGATCAGCCATCAGCATCAGCTAACGATCAGCACCAATCAGCTATCAGCTATCAGCTAAATTGATCAGCATCAGCGATTATCAGCATCAGCCTGATCAGCTATCAGCGGGTCATCAGCATCAGCATCAGCAGCTGCTTCAATCAGCAATCAGCATCAGCAACAGCCAGGGATCAGCCATCAGCGTGTTATCAGCTTTATCAGCATCAGCATCAGCCCTGATCAGCTCATCAGCCAGATCAGCTTAATCAGCAGAATCAGCATCAGCATTGATCAGCATCAGCAAATCAGCGGATCAGCAGTAATCAGCGGGGGAATCAGCATCAGCGATCAGCCCATCAGCTGTTCGATCAGCCATCAGCATCAGCTGACCATCAGCTTTAAATCAGCATTCTTATCAGCATCAGCGAGCATTGTAAATCAGCCACGATCAGCATCAGCAAATCAGCCAAGTTTCCGCATCAGCATCAGCGCTCAATCAGCATCAGCTGAAATCAGCCCTGTATCAGCATCAGCCTAACATCAGCATCAGCGACTCATCAGCCATCAGCATCAGCGACAGATCAGCGGATCAGCTCCCATCAGCATCAGCATATCAGCATCAGCTAATCAGCAATCAGCGATCAGCCGCGAATTAAATCAGCCTATCAGCGATCAGCATATCAGCATCAGCCATCAGCTGCGATCAGCATCAGCATCAGCGGCTTTATCAGCCCGATCAGCTGATCAGCTAGACGATCAGCCAAATCAGCATCAGCTGATCAGCGATATCAGCGATCAGCATGATCAGCGATCAGCTCATCAGCTATCAGCACTATCAGCGAGATCAGCATCAGCGTATTCTGGGATCAGCGATCAGCGGAATATCAGCATCAGCTATCAGCATCAGCATCAGCTACCGTGACTATCAGCATCAGCGTTCTACATCAGCTCACATCTGCTTATCAGCATCAGCTCGGCGCCCTCTTGTCAATATATCAGCAACTTAATCAGCATCAGCTAATCAGCAGTAATCAGCATCAGCAATCAGCGACGATAAGCTCATTGTAGGATCAGCGAAAATCAGCAGCATCAGCGATCAGCAATCAGCATCAGCGTACATCAGCATCAGCATCAGCTTATCAGCGGATATCAGCATCAGCATCAGCCGATCAGCATCGATCAGCAGATCAGCTAAATCAGCAGATCAGCCATCAGCGGTTTGGATCAGCTAATCAGCAATCAGCATCAGCATCAGCTAATCAGCATCAGCAATCAGCTACTGATCAGCCCTCACATCAGCTGGTGGTAGATCAGCTATAATCAGC");
			string result = concatenate(matches);
			printResults(result);
			Assert::AreEqual(expected, result);
		}

		TEST_METHOD(Native_FindExactPattern_Vibrio_cholerae_9mer)
		{
			string expected = "116556 149355 151913 152013 152394 186189 194276 200076 224527 307692 479770 610980 653338 679985 768828 878903 985368";
			size_t length;
			std::string genome = readTextDataFile("Vibrio_cholerae.txt", &length);
			vector<size_t> matches = findExactPattern("ATGATCAAG", genome);
			string result = concatenate(matches);
			printResults(result);
			Assert::AreEqual(expected, result);
		}

		TEST_METHOD(Native_FindExactPattern_Vibrio_cholerae_9mer2)
		{
			string expected = "60039 98409 129189 152283 152354 152411 163207 197028 200160 357976 376771 392723 532935 600085 622755 1065555";
			size_t length;
			std::string genome = readTextDataFile("Vibrio_cholerae.txt", &length);
			vector<size_t> matches = findExactPattern("CTTGATCAT", genome);
			string result = concatenate(matches);
			printResults(result);
			Assert::AreEqual(expected, result);
		}

		TEST_METHOD(Native_FindExactPattern_E_coli_Times_10)
		{
			string expected = "1505983 4367133 6145658 9006808 10785333 13646483 15425008 18286158 20064683 22925833 24704358 27565508 29344033 32205183 33983708 36844858 38623383 41484533 43263058 46124208";
			size_t length;
			std::string genome = readTextDataFile("E_coli_Times_10.txt", &length);
			vector<size_t> matches = findExactPattern("CTTGATCATA", genome);
			string result = concatenate(matches);
			printResults(result);
			writeToClipboard(result);
			Assert::AreEqual(expected, result);
		}

	};
}