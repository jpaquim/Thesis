/*
 * Uniform random floats:  How to generate a double-precision
 * floating-point number in [0, 1] uniformly at random given a uniform
 * random source of bits.
 *
 *    Copyright (c) 2014, Taylor R Campbell
 *
 *    Verbatim copying and distribution of this entire article are
 *    permitted worldwide, without royalty, in any medium, provided
 *    this notice, and the copyright notice, are preserved.
 *
 * The naive approach of generating an integer in {0, 1, ..., 2^k - 1}
 * for some k and dividing by 2^k, as used by, e.g., Boost.Random and
 * GCC 4.8's implementation of C++11 uniform_real_distribution, gives a
 * nonuniform distribution:
 *
 * - If k is 64, a natural choice for the source of bits, then because
 * the set {0, 1, ..., 2^53 - 1} is represented exactly, whereas many
 * subsets of {2^53, 2^53 + 1, ..., 2^64 - 1} are rounded to common
 * floating-point numbers, outputs in [0, 2^-11) are underrepresented.
 *
 * - If k is 53, in an attempt to avoid nonuniformity due to rounding,
 * then numbers in (0, 2^-53) and 1 will never be output.  These
 * outputs have very small, but nonnegligible, probability: the Bitcoin
 * network today randomly guesses solutions every ten minutes to
 * problems for which random guessing has much, much lower probability
 * of success, closer to 2^-64.
 *
 * What is the `uniform' distribution we want, anyway?  It is obviously
 * not the uniform discrete distribution on the finite set of
 * floating-point numbers in [0, 1] -- that would be silly.  For our
 * `uniform' distribution, we would like to imagine[*] drawing a real
 * number in [0, 1] uniformly at random, and then choosing the nearest
 * floating-point number to it.
 *
 * To formalize this, start with the uniform continuous distribution on
 * [0, 1] in the real numbers, whose measure is mu([a, b]) = b - a for
 * any [a, b] contained in [0, 1].  Next, let rho be the default
 * (round-to-nearest/ties-to-even) rounding map from real numbers to
 * floating-point numbers, so that, e.g., rho(0.50000000000000001) =
 * 0.5.
 *
 * Note that the preimage under rho of any floating-point number --
 * that is, for a floating-point number x, the set of real numbers that
 * will be rounded to x, or { u \in [0, 1] : rho(u) = x } -- is an
 * interval.  Its measure, mu(rho^-1(x)), is the measure of the set of
 * numbers in [0, 1] that will be rounded to x, and that is precisely
 * the probability we want for x in our `uniform' distribution.
 *
 * Instead of drawing from real numbers in [0, 1] uniformly at random,
 * we can imagine drawing from the space of infinite sequences of bits
 * uniformly at random, say (0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, ...), and
 * interpreting the result as the fractional part of the binary
 * expansion of a real number in [0, 1]:
 *
 *   0*(1/2) + 0*(1/4) + 0*(1/8) + 1*(1/16) + 0*(1/32) + 1*(1/64) + ...
 *
 * Then if we round that number, we'll get a floating-point number with
 * the desired probability.  But we can't just directly compute that
 * sum one term at a time from left to right: once we get to 53
 * significant bits, further bits will be rounded away by addition, so
 * the result will be biased to be `even', i.e. to have zero least
 * significant bit.  And we obviously can't choose uniformly at random
 * from the space of infinite sequences of bits and round the result.
 *
 * We can, however, choose finite sequences of bits uniformly at
 * random, and, except for a detail about ties, after a certain
 * constant number of bits, no matter what further bits we choose they
 * won't change what floating-point number we get by rounding.  So we
 * can choose a sufficiently large finite sequence of bits and round
 * that, knowing that the result of rounding would not change no matter
 * how many extra bits we add.
 *
 * The detail about ties is that if we simply choose, say, 1088 bits --
 * the least multiple of 64 greater than the exponent of the smallest
 * possible (subnormal) floating-point number, 2^-1074 -- and round it
 * in the default round-to-nearest/ties-to-even mode, the result would
 * be biased to be even.
 *
 * The reason is that the probability of seeing a tie in any finite
 * sequence of bits is nonzero, but but real ties occur only in sets of
 * measure zero -- they happen only when *every* remaining bit in the
 * infinite sequence is also zero.  To avoid this, before rounding, we
 * can simulate a sticky bit by setting the least significant bit of
 * the finite sequence we choose, in order to prevent rounding what
 * merely looks approximately like a tie to even.
 *
 * One little, perhaps counterintuitive, detail remains: the boundary
 * values, 0 and 1, have half the probability you might naively expect,
 * because we exclude from consideration the half of the interval
 * rho^-1(0) below 0 and the half of the interval rho^-1(1) above 1.
 *
 * Some PRNG libraries provide variations on the naive algorithms that
 * omit one or both boundary values, in order to allow, e.g., computing
 * log(x) or log(1 - x).  For example, instead of drawing from {0, 1,
 * ..., 2^53 - 1} and dividing by 2^53, some
 *
 * - divide by 2^53 - 1 instead, to allow both boundary points;
 * - draw from {1, 2, ..., 2^53} instead, to omit 0 but allow 1; or
 * - draw from {-2^52, -2^52 + 1, ..., 2^52 - 2, 2^52 - 1} (i.e., the
 * signed rather than unsigned 53-bit integers) and then add 1/2 before
 * dividing, to omit both boundary points.
 *
 * These algorithms still have the biases described above, however.
 * Given a uniform distribution on [0, 1], you can always turn it into
 * a uniform distribution on (0, 1) or (0, 1] or [0, 1) by rejection
 * sampling if 0 or 1 is a problem.
 *
 * The code below demonstrates all three algorithms with brief notes:
 * - random_real_64, which chooses and normalizes a 64-bit integer;
 * - random_real_53, which chooses and normalizes a 53-bit integer; and
 * - random_real, which chooses and rounds a binary expansion.
 * They are written in terms of a uniform random source of 64-bit
 * integers spelled random64.  This is usually more convenient than a
 * source of fair coin flips.
 *
 * WARNING: I have only proved the code correct; I have not tested it.
 *
 * Generating 64-bit integers uniformly at random is left as an
 * exercise for the crypto-minded reader.
 *
 * Thanks to Steve Canon and Alex Barnett for explaining the binary
 * expansion approach to me and talking the problem over.
 *
 * [*] For the pedantic who may stumble upon this before reading ahead,
 * we cannot, of course, assign a meaningful probability to a choice of
 * real number in [0, 1].  What we can do, however, is imagine that it
 * were meaningful, and then formalize it in the next sentence with the
 * correct sense of measure.
 */

#include <math.h>
#include <stdint.h>

uint64_t	random64(void);

/*
 * random_real_64: Pick an integer in {0, 1, ..., 2^64 - 1} uniformly
 * at random, convert it to double, and divide it by 2^64.  Values in
 * [2^-11, 1] are overrepresented, small exponents have low precision,
 * and exponents below -64 are not possible.
 */
double
random_real_64(void)
{

	return ldexp((double)random64(), -64);
}

/*
 * random_real_53: Pick an integer in {0, 1, ..., 2^53 - 1} uniformly
 * at random, convert it to double, and divide it by 2^53.  Many
 * possible outputs are not represented: 2^-54, 1, &c.  There are a
 * little under 2^62 floating-point values in [0, 1], but only 2^53
 * possible outputs here.
 */
double
random_real_53(void)
{

	return ldexp((double)(random64() & ((1ULL << 53) - 1)), -53);
}

#define	clz64	__builtin_clzll		/* XXX GCCism */

/*
 * random_real: Generate a stream of bits uniformly at random and
 * interpret it as the fractional part of the binary expansion of a
 * number in [0, 1], 0.00001010011111010100...; then round it.
 */
double
random_real(void)
{
	int exponent = -64;
	uint64_t significand;
	unsigned shift;

	/*
	 * Read zeros into the exponent until we hit a one; the rest
	 * will go into the significand.
	 */
	while (__predict_false((significand = random64()) == 0)) {
		exponent -= 64;
		/*
		 * If the exponent falls below -1074 = emin + 1 - p,
		 * the exponent of the smallest subnormal, we are
		 * guaranteed the result will be rounded to zero.  This
		 * case is so unlikely it will happen in realistic
		 * terms only if random64 is broken.
		 */
		if (__predict_false(exponent < -1074))
			return 0;
	}

	/*
	 * There is a 1 somewhere in significand, not necessarily in
	 * the most significant position.  If there are leading zeros,
	 * shift them into the exponent and refill the less-significant
	 * bits of the significand.  Can't predict one way or another
	 * whether there are leading zeros: there's a fifty-fifty
	 * chance, if random64 is uniformly distributed.
	 */
	shift = clz64(significand);
	if (shift != 0) {
		exponent -= shift;
		significand <<= shift;
		significand |= (random64() >> (64 - shift));
	}

	/*
	 * Set the sticky bit, since there is almost surely another 1
	 * in the bit stream.  Otherwise, we might round what looks
	 * like a tie to even when, almost surely, were we to look
	 * further in the bit stream, there would be a 1 breaking the
	 * tie.
	 */
	significand |= 1;

	/*
	 * Finally, convert to double (rounding) and scale by
	 * 2^exponent.
	 */
	return ldexp((double)significand, exponent);
}
